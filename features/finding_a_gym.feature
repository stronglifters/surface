Feature: Finding a gym
  As an athlete, I want to find gyms that are near me
  So that I can get a good work out.

  Scenario: Find a gym
    Given the user is on the gyms page
    When I look at the page
    Then it lists all gyms

  Scenario: Find a gym in a city
    Given the user is on the gyms page
    When I choose a city
    Then it lists all gyms
