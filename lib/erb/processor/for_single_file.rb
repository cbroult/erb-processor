# frozen_string_literal: true

require "erb"
require "find"

module Erb
  module Processor
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
        ERB.new(template_content, trim_mode: "<>-").result
      end

      def template_content
        IO.read(template_path)
      end
    end
  end
end
