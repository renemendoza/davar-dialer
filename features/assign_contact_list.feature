Feature: Assign Contact Lists to agents
As an administrator
I want to be able to assign the lists on the systems to the different agents

  Background:
    Given the following agent records
      | name         | username  | password  |   admin |
      |Rene Mendoza  | rene      |  1234     |   true  |
      |John Doe      | john      |  foobar   |   false |
      |Mary Smith    | mary      |  foobar   |   false |


  Scenario: Assign a 3 contact list to an agent with no lists
    Given I am logged in as "rene" with password "1234"
      And I upload a file with 3 valid contacts
    When I follow "Assign to agent"
