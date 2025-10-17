# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new do |t|
  t.options = ["--autocorrect"]
end

require "rubygems"
require "cucumber"
require "cucumber/rake/task"

# if false
#   Cucumber::Rake::Task.new(:cucumber) do |t|
#     t.cucumber_opts = ["--format pretty"] # Any valid command line option can go here.
#   end
# end

# Cucumber::Rake::Task.new if false

# rubocop:disable Rails/RakeEnvironment
desc "Run cucumber"
task :cucumber do
  system "bundle exec cucumber"
end
# rubocop:enable Rails/RakeEnvironment

task default: %i[spec rubocop cucumber]

desc "Upgrade gems, including bundler and gem"
task upgrade: :environment do
  sh "gem update --system"
  sh "gem update"
  sh "bundle update --bundler"
  sh "bundle update"
end
