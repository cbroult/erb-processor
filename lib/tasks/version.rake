# frozen_string_literal: true

def validate_version_type(type)
  valid_types = %w[patch minor major]
  return if valid_types.include?(type)

  puts "Error: Version type must be one of: #{valid_types.join(', ')}"
  exit 1
end

def execute_version_bump(type)
  puts "Bumping #{type} version..."
  bump_result = system("bundle exec gem bump --version #{type} --message 'build(deps): bump version to %<version>s.'")
  return if bump_result

  puts "Error: Failed to bump version"
  exit 1
end

def update_gemfile_lock
  puts "Updating Gemfile.lock..."
  bundle_result = system("bundle install")
  return if bundle_result

  puts "Error: Failed to update Gemfile.lock"
  exit 1
end

def amend_commit_to_include_gemfile_lock_changes
  puts "Amending commit to include Gemfile.lock update..."
  system("git add .")
  system("git commit --amend --no-edit")
end

namespace :version do
  desc "Bump version (patch, minor, major) and update Gemfile.lock in a single step. Default: patch"
  task :bump, [:type] => :environment do |_t, args|
    args.with_defaults(type: "patch")

    validate_version_type(args.type)

    execute_version_bump(args.type)
    update_gemfile_lock
    amend_commit_to_include_gemfile_lock_changes

    puts <<~EOEM
      Version successfully bumped and committed!

      Run 'git push' to push the changes to your remote repository.
    EOEM
  end
end

desc "Alias for version:bump"
task :bump, [:type] => ["version:bump"]
