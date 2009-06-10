Feature: Generating a "create" action
  As a developer
  I want to generate a "create" action
  So that I don't have to manually code it

  Scenario: POSTing valid form parameters
    Given a mounted model
    When I make a POST request with valid form params
    Then a record is created
    And the response redirects to the record show page
  
  Scenario: POSTing invalid form parameters
    Given a mounted model
    When I make a POST request with invalid form params
    Then a record is not created
    And I should see "So, you want to create a new Person?"
