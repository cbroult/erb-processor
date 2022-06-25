# frozen_string_literal: true

require_relative "processor/logging_setup"

require_relative "processor/version"
require_relative "processor/for_directory_tree"

class ERB
  module Processor
    class Error < StandardError; end
    # Your code goes here...
  end
end
