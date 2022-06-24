Feature: Allow logging
  In order to facilitate maintenance
  As a developer
  I need the ability to log the performed activities

  Background:
    Given an empty file named "file.cpp.erb"
    Given an empty file named "dir/file.cpp.erb"
    Given an empty file named "dir/another_file.js.erb"
    Given an empty file named "another_dir/features/file.feature.erb"
    Given an empty file named "another_dir/file.java.erb"

  Scenario: Processor is silent on the console by default
    When I successfully run `erb-processor .`
    Then the output should not contain anything
    And a file named "erb-processor.log" should contain exactly:
       """
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/features/file.feature.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/features/file.feature
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/file.java.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/file.java
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/another_file.js.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/another_file.js
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/file.cpp
        INFO  Erb::Processor::ForSingleFile : Processing ./file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./file.cpp
       """

  Scenario: Processor logs info to the console
    When I successfully run `erb-processor --log-level=info .`
    Then the stdout should contain exactly:
       """
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/features/file.feature.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/features/file.feature
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/file.java.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/file.java
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/another_file.js.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/another_file.js
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/file.cpp
        INFO  Erb::Processor::ForSingleFile : Processing ./file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./file.cpp
       """
    And a file named "erb-processor.log" should contain exactly:
       """
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/features/file.feature.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/features/file.feature
        INFO  Erb::Processor::ForSingleFile : Processing ./another_dir/file.java.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./another_dir/file.java
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/another_file.js.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/another_file.js
        INFO  Erb::Processor::ForSingleFile : Processing ./dir/file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./dir/file.cpp
        INFO  Erb::Processor::ForSingleFile : Processing ./file.cpp.erb...
        INFO  Erb::Processor::ForSingleFile : Wrote ./file.cpp
       """
