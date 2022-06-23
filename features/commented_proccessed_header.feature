Feature: Generate commented processed header
  In order to include a processed header in the processed files
  As programming language
  I need a properly commented header

  Scenario: C Language Template
    Given a file named "code.c.erb" with:
      """
      <%= commented_processed_header %>

      some code
      """
    When I run `erb-processor .`
    Then a file named "code.c" should contain exactly:
      """
      //
      // WARNING: DO NOT EDIT directly
      //
      // HOWTO Modify this file
      // 1. Edit the file code.c.erb
      // 2. $ erb-processor .
      //

      some code
      """
      
