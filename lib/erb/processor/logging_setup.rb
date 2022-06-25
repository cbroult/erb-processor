# frozen_string_literal: true

require "logging"
require "singleton"

class ERB
  module Processor
    # Configure the logging framework according the process needs
    class LoggingSetup
      include Singleton

      def run(console_log_level)
        configure_appenders(console_log_level)
      end

      def configure_appenders(console_log_level)
        Logging.logger.root.level = :info

        # similarly, the root appender will be used by all loggers
        file_appender = Logging.appenders.file("erb-processor.log")
        file_appender.level = :info

        console_appender.level = console_log_level

        Logging.logger.root.appenders = [file_appender, console_appender]
      end

      def console_appender
        @console_appender ||= Logging.appenders.stdout
      end
    end
  end
end
