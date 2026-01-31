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

task default: :verify

desc "Run all verification tasks"
task verify: %i[spec cucumber rubocop]

def upgrade_gems
  sh "gem update --system"
  sh "gem update"
  sh "bundle update --bundler"
  sh "bundle update --all"
  sh "bundle audit"
end

namespace :upgrade do
  desc "Update gems automatically (branch to push and release)"
  task auto: %i[branch gems verify commit version:bump release push]

  desc "Create a branch for the upgrade"
  task branch: :environment do
    sh "git checkout main"
    sh "git pull"
    sh "git branch -D upgrade/gems" unless `git branch --list upgrade/gems`.chomp.empty?
    sh "git checkout -b upgrade/gems"
  end

  desc "Commit the upgrade branch"
  task commit: :environment do
    sh "git add Gemfile Gemfile.lock"
    sh "git commit -m 'chore(deps): upgrade gems'"
  end

  desc "Upgrade gems, including bundler and gem"
  task gems: :environment do
    upgrade_gems
  end

  desc "Alias for upgrade:auto"
  task upgrade: "upgrade:auto"

  desc "Push the upgrade"
  task push: :environment do
    sh "git push origin upgrade/gems"
  end
end
