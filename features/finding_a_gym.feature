Feature: Finding a gym
  As an athlete, I want to find gyms that are near me
  So that I can get a good work out.

  Scenario: Find a gym
    Given the user is logged in
    And There are 2 gyms
    When the user is on the gyms page
    Then it lists all gyms

  Scenario: Find a gym in a city
    Given the user is logged in
    And There are 3 gyms
    When the user is on the gyms page
    And they search for a city
    Then it lists all gyms
