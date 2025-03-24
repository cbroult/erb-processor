# frozen_string_literal: true

require "find"
require_relative "for_single_file"

class ERB
  module Processor
    # Convert text to a comment depending on the target language
    class LanguageCommenter
      def self.comment_for(target_file_path, text_to_comment); end

      attr_reader :target_file_path, :text_to_comment

      def initialize(target_file_path, text_to_comment)
        @target_file_path = target_file_path
        @text_to_comment = text_to_comment
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
          html: ["<!--", "-->"],
          feature: ["#", nil]
        }.freeze

      def commented_text
        comment_start, comment_end = *LANGUAGE_COMMENTS.fetch(processed_language) { NO_COMMENT_MARKER }

        return text_to_comment unless comment_start

        if comment_end
          [comment_start, NEWLINE, text_to_comment, comment_end, NEWLINE].join
        else
          text_to_comment.lines.collect { |line| [comment_start, line].join(SPACE) }.join
        end
      end

      FILE_EXTENSION_REGEX = /\.([^.]+)$/
      def processed_language
        if target_file_path =~ FILE_EXTENSION_REGEX
          Regexp.last_match(1).intern
        else
          :unknown
        end
      end
    end
  end
end
