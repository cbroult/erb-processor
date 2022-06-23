Feature: Process all ERB files in a directory tree
  In order to easily leverage active code generation
  As a developer
  I need the ability to systematically process all ERB files in a directory tree structure

  Scenario: All ERB files are processed
    Given an empty file named "file.cpp.erb"
    Given an empty file named "dir/file.cpp.erb"
    Given an empty file named "dir/another_file.js.erb"
    Given an empty file named "another_dir/features/file.feature.erb"
    Given an empty file named "another_dir/file.java.erb"
    When I successfully run `erb-processor .`
    Then the following files should exist:
    | file.cpp |
    | dir/file.cpp |
    | dir/another_file.js |
    | another_dir/features/file.feature |
    | another_dir/file.java |


  Scenario: Content is processed as per the template content
    Given a file named "foo.feature.erb" with:
      """
      <% SCENARIOS_PENDING_AUTOMATION = 10 -%>
      Feature: Accounting for all scenarios pending automation

      <% SCENARIOS_PENDING_AUTOMATION.times do |i| -%>
        Scenario: Scenario <%= i+1 %> of <%= SCENARIOS_PENDING_AUTOMATION %> pending automation

      <% end -%>

      """
    When I successfully run `erb-processor .`
    Then a file named "foo.feature" should contain exactly:
      """
      Feature: Accounting for all scenarios pending automation

        Scenario: Scenario 1 of 10 pending automation

        Scenario: Scenario 2 of 10 pending automation

        Scenario: Scenario 3 of 10 pending automation

        Scenario: Scenario 4 of 10 pending automation

        Scenario: Scenario 5 of 10 pending automation

        Scenario: Scenario 6 of 10 pending automation

        Scenario: Scenario 7 of 10 pending automation

        Scenario: Scenario 8 of 10 pending automation

        Scenario: Scenario 9 of 10 pending automation

        Scenario: Scenario 10 of 10 pending automation

      """

  Scenario: Existing procesed file is overwritten
    Given a file named "foo.bar.erb" with:
      """
      Updated template <%= 4**2 -%>
      """
    Given a file named "foo.bar" with:
      """
      Previous procesed content
      """
    When I successfully run `erb-processor .`
    Then the file named "foo.bar" should contain exactly:
      """
      Updated template 16
      """
