Feature: Signing in

  Scenario: Unsuccessful signin
    Given users visit signin page
    When they submit invalid signin information
    Then they should see error message
    
  Scenario: Successful sigin
    Given users visit sigin page
    And the user has an account
    When the user submit valid information
    Then they should see their profile page
    And they should see signout link