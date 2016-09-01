require "chef/cookbook/metadata"
require "mixlib/shellout"

module Drone
  class Supermarket
    #
    # Class for uploading cookbooks to a Chef Supermarket
    #
    class Processor
      attr_accessor :config

      #
      # Initialize an instance
      #
      def initialize(config)
        self.config = config

        yield(
          self
        ) if block_given?
      end

      #
      # Validate that all requirements are met
      #
      def validate!
        unless File.exist? "#{@config.workspace.path}/metadata.rb"
          raise "Missing cookbook metadata.rb"
        end
        unless File.exist? "#{@config.workspace.path}/README.md"
          raise "Missing cookbook README.md"
        end
      end

      #
      # Write required config files
      #
      def configure!
        config.configure!

        write_knife_rb
      end

      #
      # Upload the cookbook to a Chef Supermarket
      #
      def upload!
        check_upload_status

        if uploaded?
          log.info "Cookbook #{cookbook_version} " \
                   "already uploaded to #{@config.server}" if uploaded?
          return
        end

        knife_upload
      end

      protected

      def write_knife_rb # rubocop:disable AbcSize
        config.knife_config_path.open "w" do |f|
          f.puts "node_name '#{@config.user}'"
          f.puts "client_key '#{@config.keyfile_path}'"
          f.puts "cookbook_path '#{Pathname.new(@config.workspace.path).parent}'" # rubocop:disable LineLength
          f.puts "ssl_verify_mode #{@config.ssl_mode}"
          f.puts "knife[:supermarket_site] = '#{@config.server}'"
        end
      end

      #
      # Upload any roles, environments and data_bags
      #
      def knife_upload # rubocop:disable AbcSize, MethodLength
        command = ["knife supermarket share #{cookbook.name}"]
        command << "-c #{@config.knife_config_path}"
        cmd = Mixlib::ShellOut.new(command.join(" "))
        cmd.run_command

        if cmd.error?
          log.error "knife supermarket share stdout: #{cmd.stdout}"
          log.error "knife supermarket share stderr: #{cmd.stderr}"
        else
          log.debug "knife supermarket share stdout: #{cmd.stdout}"
          log.debug "knife supermarket share stderr: #{cmd.stderr}"
        end

        raise "Failed to upload cookbook" if cmd.error?
        log.info "Finished uploading #{cookbook_version} to #{@config.server}"
      end

      def check_upload_status
        log.info "Checking if #{cookbook_version} " \
                 "is already shared to #{@config.server}"
        knife_show
      end

      def uploaded?
        @uploaded ||= knife_show
      end

      def knife_show
        command = ["knife supermarket show #{cookbook.name} #{cookbook.version}"] # rubocop:disable LineLength
        command << "-c #{@config.knife_config_path}"
        cmd = Mixlib::ShellOut.new(command.join(" "))
        cmd.run_command
        log.debug "knife supermarket share stdout:\n#{cmd.stdout}"
        @uploaded = !cmd.error?
      end

      def cookbook
        @metadata ||= begin
          metadata = ::Chef::Cookbook::Metadata.new
          metadata.from_file("#{@config.workspace.path}/metadata.rb")
          metadata
        end
      end

      def cookbook_version
        "#{cookbook.name}@#{cookbook.version}"
      end

      def log
        config.logger
      end
    end
  end
end
