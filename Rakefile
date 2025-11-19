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

# Load custom tasks
Dir.glob("lib/tasks/**/*.rake").each { |r| load r }

# if false
#   Cucumber::Rake::Task.new(:cucumber) do |t|
#     t.cucumber_opts = ["--format pretty"] # Any valid command line option can go here.
#   end
# end

# Cucumber::Rake::Task.new if false

desc "Run cucumber"
task cucumber: :environment do
  system "bundle exec cucumber"
end

# rubocop:disable Rails/RakeEnvironment
desc "Run environment specific tasks"
task :environment do
  :nothing
end
# rubocop:enable Rails/RakeEnvironment

task default: %i[spec rubocop cucumber]

desc "Upgrade gems, including bundler and gem"
task upgrade: :environment do
  sh "gem update --system"
  sh "gem update"
  sh "bundle update --bundler"
  sh "bundle update"
  sh "bundle audit"
end
