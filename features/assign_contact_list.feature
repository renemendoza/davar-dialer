Feature: Assign Contact Lists to agents
As an administrator
I want to be able to assign the lists on the systems to the different agents

  Background:
    Given the following agent records
      | name         | username  | password  |   admin |
      |Rene Mendoza  | rene      |  1234     |   true  |
      |John Doe      | john      |  foobar   |    |
      |Mary Smith    | mary      |  foobar   |    |


    
  Scenario: Upload a file with 3 contacts as an administrator and assign contacts to an agent
    And I am logged in as "rene" with password "1234"
    When I upload a file with 3 valid contacts 
    And I import it
    And I follow "Assign"
    And I choose contact number 1 and contact number 2 
    And I choose agent "John Doe"
    And I press "Assign to agent"
    Then I should see "2 Contacts assigned"
