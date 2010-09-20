Feature: Manage Agents
  In order to be able to quickly contact a number of customers
  As an agent
  I need to do be able to register to use the system and to change my settings as well

  Background:
    Given the following agent records
      | name         | username  | password  | 
      |Rene Mendoza  | rene      |  1234     |    
      |Davar Fazaeli | davar     |  secret   |    

  Scenario: New Agent Registration
    When I am on the login page
      And I follow "Register"
      And I fill in "Name" with "John Doe"
      And I fill in "Email Address" with "john@yahoo.com.mx"
      And I fill in "Username" with "johndoe"
      And I fill in "Password" with "1234"
      And I fill in "Confirm your Password" with "1234"
      And I fill in "Callback Number" with "5619521007"
      And I press "Register"
    Then I should see "New agent created."

  Scenario: Agent Update
    Given I am logged in as "rene" with password "1234"
    When I follow "Settings"
      And I fill in "Callback Number" with "5619521007"
      And I press "Update"
    Then I should see "Agent settings updated."
