# frozen_string_literal: true

require "find"
require_relative "for_single_file"

module Erb
  module Processor
    # Orchestrate the processing of all .erb templates in tree structure
    class ForDirectoryTree
      attr_reader :paths

      def initialize(paths)
        @paths = paths
      end

      def run
        Find.find(*paths) do |path|
          next unless ForSingleFile.template_file?(path)

          ForSingleFile.new(path).run
        end
      end
    end
  end
end
