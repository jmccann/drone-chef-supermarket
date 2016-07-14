require "spec_helper"

describe Drone::Supermarket::Config do
  include FakeFS::SpecHelpers

  let(:options) do
    {
      server: "https://myserver.com",
      user: "jane",
      private_key: "PEMDATAHERE",
      ssl_verify: "false"
    }
  end

  let(:file) { double("File") }

  let(:config) do
    Drone::Supermarket::Config.new options
  end

  before do
    allow(Dir).to receive(:home).and_return "/root"
  end

  describe "#configure!" do
    it "writes key file" do
      allow(config).to receive(:write_netrc)

      expect(File).to receive(:open).with("/tmp/key.pem", "w").and_yield(file)
      expect(file).to receive(:write).with("PEMDATAHERE")

      config.configure!
    end
  end

  describe "#ssl_mode" do
    it "returns value to disable ssl verify in knife" do
      options[:ssl_verify] = "false"
      expect(config.ssl_mode).to eq ":verify_none"
    end

    it "returns value to enable ssl verify in knife" do
      options[:ssl_verify] = "true"
      expect(config.ssl_mode).to eq ":verify_peer"
    end
  end

  describe "#knife_config_path" do
    it "returns the file path" do
      FakeFS do
        expect(config.knife_config_path.to_s).to eq "/root/.chef/knife.rb"
      end
    end

    it "creates the directory structure if it doesn't exist" do
      FakeFS do
        # Test that it does not exist yet
        expect(Dir.exist?("/root/.chef")).to eq false

        # Run the code
        config.knife_config_path

        # Test that it exists now
        expect(Dir.exist?("/root/.chef")).to eq true
      end
    end
  end

  # describe '#debug?' do
  #   subject { config.debug? }
  #
  #   context "build is false" do
  #     before do
  #       options["debug"] = false
  #     end
  #
  #     it { is_expected.to eq false }
  #   end
  #   context "build is true" do
  #     before do
  #       options["debug"] = true
  #     end
  #
  #     it { is_expected.to eq true }
  #   end
  # end
end
