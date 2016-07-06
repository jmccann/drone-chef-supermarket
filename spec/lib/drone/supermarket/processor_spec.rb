require "spec_helper"

describe Drone::Supermarket::Processor do
  include FakeFS::SpecHelpers

  let(:options) do
    {
      "server" => "https://myserver.com",
      "user" => "jane",
      "private_key" => "PEMDATAHERE",
      "ssl_verify" => false
    }
  end

  let(:stringio) do
    StringIO.new
  end

  let(:logger) do
    Logger.new stringio
  end

  let(:config) do
    Drone::Supermarket::Config.new options, logger
  end

  let(:processor) do
    Drone::Supermarket::Processor.new config
  end

  let(:knife_show_shellout) do
    double("knife supermarket show test_cookbook", run_command: nil,
                                                   stdout: "show output",
                                                   stderr: "show error",
                                                   error?: false)
  end

  let(:knife_share_shellout) do
    double("knife supermarket share test_cookbook", run_command: nil,
                                                    stdout: "share output",
                                                    stderr: "share error",
                                                    error?: false)
  end

  let(:cookbook) do
    instance_double("Chef::Cookbook::Metadata", name: "test_cookbook",
                                                version: "1.2.3",
                                                from_file: nil)
  end

  before do
    allow(Mixlib::ShellOut).to receive(:new).and_return nil

    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?)
      .with("/path/to/project/metadata.rb").and_return(true)
    allow(File).to receive(:exist?)
      .with("/path/to/project/README.md").and_return(true)
    allow(processor).to receive(:cookbook).and_return(cookbook)

    allow(Mixlib::ShellOut)
      .to receive(:new).with(/knife supermarket show/)
      .and_return knife_show_shellout
    allow(Mixlib::ShellOut)
      .to receive(:new).with(/knife supermarket share/)
      .and_return knife_share_shellout
  end

  describe '#validate!' do
    before do
      allow(Dir).to receive(:pwd).and_return "/path/to/project"
    end

    it "passes when org is provided" do
      expect { processor.validate! }.not_to raise_error
    end

    it "fails if metadata.rb is missing" do
      expect(File).to receive(:exist?)
        .with("/path/to/project/metadata.rb").and_return false
      expect { processor.validate! }
        .to raise_error("Missing cookbook metadata.rb")
    end

    it "fails if README.md is missing" do
      expect(File).to receive(:exist?)
        .with("/path/to/project/README.md").and_return false
      expect { processor.validate! }
        .to raise_error("Missing cookbook README.md")
    end
  end

  describe '#configure!' do
    before do
      allow(config).to receive(:configure!)
    end

    it "calls configure from Drone::Supermarket::Config" do
      expect(config).to receive(:configure!)

      processor.configure!
    end

    context "writes the knife config" do
      before do
        allow(Dir).to receive(:home).and_return "/root"
        allow(Dir).to receive(:pwd).and_return "/path/to/project"
      end

      it "includes the username" do
        FakeFS do
          processor.configure!

          expect(File.read("/root/.chef/knife.rb"))
            .to include "node_name 'jane'"
        end
      end

      it "includes the key file path" do
        FakeFS do
          processor.configure!

          expect(File.read("/root/.chef/knife.rb"))
            .to include "client_key '/tmp/key.pem'"
        end
      end

      it "includes the cookbook_path" do
        FakeFS do
          processor.configure!

          expect(File.read("/root/.chef/knife.rb"))
            .to include "cookbook_path '/path/to'"
        end
      end

      it "includes ssl_verify_mode" do
        FakeFS do
          processor.configure!

          expect(File.read("/root/.chef/knife.rb"))
            .to include "ssl_verify_mode :verify_none"
        end
      end

      it "includes supermarket server" do
        FakeFS do
          processor.configure!

          expect(File.read("/root/.chef/knife.rb"))
            .to include "knife[:supermarket_site] = 'https://myserver.com'"
        end
      end
    end
  end

  describe '#upload!' do
    it "checks if cookbook is already uploaded" do
      expect(knife_show_shellout).to receive(:run_command)
      processor.upload!
    end

    it "shares cookbook to supermarket" do
      allow(processor).to receive(:knife_show).and_return(false)
      expect(knife_share_shellout).to receive(:run_command)
      processor.upload!
    end

    it "shows debug output when debug?" do
      allow(config).to receive(:debug?).and_return(true)

      # Fake that cookbook was not uploaded
      allow(processor).to receive(:knife_show).and_return(false)

      processor.upload!
      expect(stringio.string).to match(/DEBUG/)
    end

    it "shows upload error" do
      # Fake that cookbook was not uploaded
      allow(processor).to receive(:knife_show).and_return(false)
      allow(knife_share_shellout).to receive(:error?).and_return(true)

      expect { processor.upload! }
        .to raise_error("Failed to upload cookbook")
      expect(stringio.string).to match(/share error/)
    end

    it "does not share if already uploaded" do
      allow(processor).to receive(:knife_show).and_return(true)
      expect(processor).not_to receive(:knife_upload)
      processor.upload!
    end

    context "logging" do
      it "logs that cookbook is already shared" do
        processor.upload!

        expected_str = "Cookbook test_cookbook@1.2.3 already uploaded " \
                       "to https://myserver.com"
        expect(stringio.string).to match(expected_str)
      end

      it "logs that cookbook has been uploaded" do
        allow(processor).to receive(:knife_show).and_return(false)

        processor.upload!

        expected_str = "Finished uploading test_cookbook@1.2.3 to " \
                       "https://myserver.com"
        expect(stringio.string).to match(expected_str)
      end

      it "does debug logs" do
        processor.upload!

        expect(stringio.string).to match(/DEBUG/)
      end
    end
  end
end
