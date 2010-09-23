Feature: Upload Contact Lists (CSV)
  In order to be able to quickly contact a number of customers
  As an agent
  I want to do be able to upload a list of phone numbers that will be dialed automatically by the Phone system

  Background:
    Given the following agent records
      | name         | username  | password  |   admin |
      |Rene Mendoza  | rene      |  1234     |   true  |
      |Davar Fazaeli | davar     |  secret   |   true  |
      |John Doe      | john      |  foobar   |   false |

  Scenario: Upload a file with 3 contacts as an administrator
    Given I am logged in as "rene" with password "1234"
    When I follow "Add a new contact list"
      And I upload a file with 3 valid contacts
    Then "rene" should have a new list with 3 new contacts
      And I should see "Contact list created"
      And I should see a list with 3 contacts


  Scenario: Upload a file without administrator privileges
    Given I am logged in as "john" with password "foobar"
    When I go to the new contact list page
    Then I should see "You are not allowed to see this page"
