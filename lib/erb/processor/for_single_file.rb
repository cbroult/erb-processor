# frozen_string_literal: true

require "erb"
require "find"

module Erb
  module Processor
    # Processes a single file template
    class ForSingleFile
      ERB_TEMPLATE_REGEX = /.erb$/i.freeze

      def self.template_file?(path)
        ERB_TEMPLATE_REGEX.match?(path)
      end

      attr_reader :template_path

      def initialize(template_path)
        @template_path = template_path
      end

      FOR_WRITING = "w+"
      def run
        File.open(processed_path, FOR_WRITING) do |output|
          output.print processed_content
        end
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
        comment(processed_header)
      end

      SPACE = " "
      NEWLINE = "\n"
      NO_COMMENT_MARKER = [nil, nil].freeze
      CSTYLE_COMMENT = ["/*", "*/"].freeze
      LANGUAGE_COMMENTS =
        {
          c: CSTYLE_COMMENT,
          cpp: CSTYLE_COMMENT,
          java: CSTYLE_COMMENT,
          js: CSTYLE_COMMENT,
          py: ["#", nil],
          rb: ["=begin", "=end"],
          html: ["<!--", "-->"]
        }.freeze

      def comment(text_to_comment)
        comment_start, comment_end = *LANGUAGE_COMMENTS.fetch(processed_language) { NO_COMMENT_MARKER }

        return text_to_comment unless comment_start

        if comment_end
          [comment_start, NEWLINE, text_to_comment, comment_end, NEWLINE].join
        else
          text_to_comment.lines.collect { |line| [comment_start, line].join(SPACE) }.join
        end
      end

      FILE_EXTENSION_REGEX = /\.([^.]+)$/.freeze
      def processed_language
        if processed_path =~ FILE_EXTENSION_REGEX
          Regexp.last_match(1).intern
        else
          :unknown
        end
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
        IO.read(template_path)
      end
    end
  end
end
