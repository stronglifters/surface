Feature: Registration
  Allow new users to register on the website.
  As a new visitor
  I want to register for an account to gain access to the website.

  Scenario Outline: Register a new user
    Given the user is on the registration page
    When they enter a <username>, <email> and <password>
    Then it should take them to the dashboard

    Examples:
      | username | email          | password |
      | mo       | mo@example.org | password |
      | joe      | joe@example.org | the secret |
