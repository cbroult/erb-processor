# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ERB::Processor is a Ruby gem that processes all `.erb` files in a directory tree. It evaluates each ERB template and writes the output to a file with the `.erb` extension removed.

## Common Commands

```bash
# Install dependencies
bin/setup

# Run all verification (specs + cucumber + rubocop)
rake verify

# Run RSpec tests only
rake spec

# Run a single spec file
bundle exec rspec spec/erb/processor/for_single_file_spec.rb

# Run Cucumber acceptance tests
rake cucumber

# Run a single feature file
bundle exec cucumber features/process_all_erb_files.feature

# Run linter with auto-correct
rake rubocop

# Run the CLI tool
bin/erb-processor <directory>
```

## Architecture

### Core Classes (lib/erb/processor/)

- **ForDirectoryTree** - Entry point that walks a directory tree using `Find.find`, delegating each `.erb` file to `ForSingleFile`
- **ForSingleFile** - Processes a single ERB template: reads template, evaluates with ERB, writes output. Exposes `erb_processor` binding for templates to access helper methods like `commented_processed_header`
- **LanguageCommenter** - Generates language-appropriate comment syntax (C-style, Python, Ruby, HTML, etc.) for the auto-generated header based on output file extension
- **LoggingSetup** - Singleton that configures the `logging` gem with console output

### Template Binding

Templates can access `erb_processor` (the `ForSingleFile` instance) to call:
- `commented_processed_header` - Returns a "DO NOT EDIT" warning commented appropriately for the target language

### Test Structure

- **spec/** - RSpec unit tests for individual classes
- **features/** - Cucumber acceptance tests using Aruba for CLI testing (see `features/*.feature` for behavior documentation)

## Commit Conventions

- Use conventional commit format: `type(scope): subject`
- Keep subject line under 50 characters
- Use present tense ("add feature" not "added feature")
- Avoid overly verbose descriptions or unnecessary details.
