Feature: Generate commented processed header
  In order to include a processed header in the processed files
  As programming language
  I need a properly commented header

  Scenario: C Language Template
    Given a file named "code.c.erb" with:
      """
      <%= erb_processor.commented_processed_header %>
      some code
      """
    When I successfully run `erb-processor .`
    Then a file named "code.c" should contain exactly:
      """
      /*

      WARNING: DO NOT EDIT directly
      
      HOWTO Modify this file
      1. Edit the file ./code.c.erb
      2. $ erb-processor .

      */

      some code
      """

  Scenario: HTML Language Template
    Given a file named "code.html.erb" with:
      """
      <%= erb_processor.commented_processed_header %>
      some code
      """
    When I successfully run `erb-processor .`
    Then a file named "code.html" should contain exactly:
      """
      <!--

      WARNING: DO NOT EDIT directly
      
      HOWTO Modify this file
      1. Edit the file ./code.html.erb
      2. $ erb-processor .

      -->

      some code
      """

  Scenario: Gherkin Language Template
    Given a file named "code.feature.erb" with:
      """
      Feature: a feature description
      <%= erb_processor.commented_processed_header %>
      some code
      """
    When I successfully run `erb-processor .`
    Then a file named "code.feature" should contain exactly:
      """
      Feature: a feature description
      # 
      # WARNING: DO NOT EDIT directly
      # 
      # HOWTO Modify this file
      # 1. Edit the file ./code.feature.erb
      # 2. $ erb-processor .
      # 

      some code
      """

  Scenario: Unknown Language Template
    Given a file named "some-exotic-code.erb" with:
      """
      <%= erb_processor.commented_processed_header -%>
      some code
      """
    When I successfully run `erb-processor .`
    Then a file named "some-exotic-code" should contain exactly:
      """
      
      WARNING: DO NOT EDIT directly
      
      HOWTO Modify this file
      1. Edit the file ./some-exotic-code.erb
      2. $ erb-processor .
      
      some code
      """

