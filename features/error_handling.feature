Feature: Template errors are reported
  In order to have confidence in the template processing
  As a user
  I need errors to be reported

  Scenario: A template that has errors
    Given a file named "code.c.erb" with:
      """
      <%= trying_to_access_an_inexisting_variable %>
      some code
      """
    When I run `erb-processor .`
    Then it should fail matching:
      """
      .*./code.c.erb:0: undefined local variable or method [`']trying_to_access_an_inexisting_variable'.*
      """
