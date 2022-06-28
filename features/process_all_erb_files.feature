Feature: Process all ERB files in a directory tree
  In order to easily leverage active code generation
  As a developer
  I need the ability to systematically process all ERB files in a directory tree structure

  Scenario: A Java file properly generated as per the template content
    Given a file named "file.java.erb" with:
      """
      <% SCENARIOS_PENDING_AUTOMATION = 4 -%>

      public class PendingTestAutomation {
      
      <% SCENARIOS_PENDING_AUTOMATION.times do |i| 
           scenario_id = i + 1
      -%>
        @Test(enabled=false)
        @Description("Test <%= scenario_id %>/<%= SCENARIOS_PENDING_AUTOMATION %> that is pending automation")
        public void toBeAutomated_<%= scenario_id %>_of_<%= SCENARIOS_PENDING_AUTOMATION %>(){}

      <% end -%>
      }
      """
    When I successfully run `erb-processor .`
    Then a file named "file.java" should contain exactly:
      """

      public class PendingTestAutomation {
      
        @Test(enabled=false)
        @Description("Test 1/4 that is pending automation")
        public void toBeAutomated_1_of_4(){}
      
        @Test(enabled=false)
        @Description("Test 2/4 that is pending automation")
        public void toBeAutomated_2_of_4(){}
      
        @Test(enabled=false)
        @Description("Test 3/4 that is pending automation")
        public void toBeAutomated_3_of_4(){}
      
        @Test(enabled=false)
        @Description("Test 4/4 that is pending automation")
        public void toBeAutomated_4_of_4(){}
      
      }
      """


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

  Scenario: Any existing procesed file is overwritten
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

  Scenario: All ERB files are processed
    Given an empty file named "file.java.erb"
    Given an empty file named "dir/file.cpp.erb"
    Given an empty file named "dir/another_file.js.erb"
    Given an empty file named "another_dir/features/file.feature.erb"
    Given an empty file named "another_dir/file.java.erb"
    When I successfully run `erb-processor .`
    Then the following files should exist:
    | file.java |
    | dir/file.cpp |
    | dir/another_file.js |
    | another_dir/features/file.feature |
    | another_dir/file.java |


