Feature: Upload Contact Lists (CSV)
  In order to be able to quickly contact a number of customers
  As an agent
  I want to do be able to upload a list of phone numbers that will be dialed automatically by the Phone system

  Scenario: Upload a file with 10 contacts
    Given I am on the new contact list page
    When I upload a file with 10 valid contacts
    Then I should have a new list with 10 contacts
