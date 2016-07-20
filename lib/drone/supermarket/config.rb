require "pathname"
require "logger"

module Drone
  class Supermarket
    #
    # Chef plugin configuration
    #
    class Config
      attr_accessor :payload, :logger

      #
      # Initialize an instance
      #
      def initialize(payload, log = nil)
        self.payload = payload
        self.logger = log || default_logger
      end

      #
      # Write config files to filesystem
      #
      def configure!
        write_keyfile
      end

      #
      # Knife flag for enabling/disabling SSL verify
      #
      # @return [String]
      #
      def ssl_mode
        to_boolean(payload[:ssl_verify]) ? ":verify_peer" : ":verify_none"
      end

      #
      # Knife config file location
      #
      def knife_config_path
        @knife_config_path ||= Pathname.new(
          Dir.home
        ).join(
          ".chef",
          "knife.rb"
        )

        @knife_config_path.dirname.tap do |dir|
          dir.mkpath unless dir.directory?
        end

        @knife_config_path
      end

      #
      # The path to write our knife keyfile to
      #
      def keyfile_path
        @keyfile_path ||= Pathname.new(
          "/tmp/key.pem"
        )
      end

      #
      # The path to write our knife keyfile to
      #
      def workspace_path
        @workspace_path ||= Pathname.new Dir.pwd
      end

      protected

      def default_logger
        @logger ||= Logger.new(STDOUT).tap do |l|
          l.level = payload[:debug] ? Logger::DEBUG : Logger::INFO
          l.formatter = proc do |sev, datetime, _progname, msg|
            "#{sev}, [#{datetime}] : #{msg}\n"
          end
        end
      end

      #
      # Write a knife keyfile
      #
      def write_keyfile
        keyfile_path.open "w" do |f|
          f.write payload[:private_key]
        end
      end

      def to_boolean(str)
        str.downcase == "true" # rubocop:disable Casecmp
      end

      # #
      # # The path to write our netrc config to
      # #
      # def netrc_path
      #   @netrc_path ||= Pathname.new(
      #     Dir.home
      #   ).join(
      #     ".netrc"
      #   )
      # end

      # #
      # # Write a .netrc file
      # #
      # def write_netrc
      #   return if netrc.nil?
      #   netrc_path.open "w" do |f|
      #     f.puts "machine #{netrc.machine}"
      #     f.puts "  login #{netrc.login}"
      #     f.puts "  password #{netrc.password}"
      #   end
      # end
    end
  end
end
