# frozen_string_literal: true

require "erb"
require "find"
require_relative "language_commenter"

module Erb
  module Processor
    # Processes a single file template
    class ForSingleFile
      ERB_TEMPLATE_REGEX = /.erb$/i.freeze

      def self.template_file?(path)
        ERB_TEMPLATE_REGEX.match?(path)
      end

      attr_reader :logger
      attr_reader :template_path

      def initialize(template_path)
        @logger = Logging.logger[self]
        @template_path = template_path
      end

      FOR_WRITING = "w+"
      def run
        logger.info { "Processing #{template_path}..." }
        File.open(processed_path, FOR_WRITING) do |output|
          output.print processed_content
        end
        logger.info { "Wrote #{processed_path}" }
      end

      def processed_path
        template_path.sub(ERB_TEMPLATE_REGEX, "")
      end

      def processed_content
        erb_processor = self

        ERB.new(template_content, trim_mode: "<>-").result binding
      rescue StandardError => e
        raise e.class, "\n#{template_path}:0: #{e}", e.backtrace
      end

      def commented_processed_header
        LanguageCommenter.new(processed_path, processed_header).commented_text
      end

      def processed_header
        <<~PROCESSED_HEADER

          WARNING: DO NOT EDIT directly

          HOWTO Modify this file
          1. Edit the file #{template_path}
          2. $ erb-processor .

        PROCESSED_HEADER
      end

      def template_content
        File.read(template_path)
      end
    end
  end
end
