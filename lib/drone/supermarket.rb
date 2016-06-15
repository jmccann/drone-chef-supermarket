module Drone
  #
  # Drone plugin for uploading artifacts to Chef Supermarket
  #
  class Supermarket
    autoload :Config,
      File.expand_path("../supermarket/config", __FILE__)

    autoload :Processor,
      File.expand_path("../supermarket/processor", __FILE__)

    attr_accessor :config

    #
    # Initialize an instance
    #
    def initialize(payload)
      self.config = Config.new(
        payload
      )
    end

    #
    # General plugin execution
    #
    def execute!
      config.validate!

      Processor.new config do |processor|
        processor.validate!
        processor.configure!
        processor.upload!
      end
    end
  end
end
