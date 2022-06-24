# frozen_string_literal: true

require_relative "lib/erb/processor/version"

Gem::Specification.new do |spec|
  spec.name = "erb-processor"
  spec.version = Erb::Processor::VERSION
  spec.authors = ["Christophe Broult"]
  spec.email = ["cbroult@yahoo.com"]

  spec.summary = "Process all .erb files in a directory tree."
  spec.description = <<~END_OF_DESCRIPTION
    All .erb files in the specified directory tree are going to be evaluated.
    The corresponding non.erb files are going to be written by removing the .erb extension.
    See the features/*.feature files for the expected behavior.
  END_OF_DESCRIPTION
  spec.homepage = "https://github.com/cbroult/erb-processor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = File.join(spec.homepage, "Changelog")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }.reject { |f| f.match(/console|setup/) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "logging", "~> 2.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
