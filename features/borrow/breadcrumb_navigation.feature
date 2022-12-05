
Feature: Breadcrumb navigation

  Background:
    Given I am Normin

  @rack
  Scenario: Breadcrumb navigation
    Given I am listing the main categories
    Then I see the breadcrumb navigation bar

  @rack
  Scenario: Home button in the breadcrumb navigation
    Given I am listing the main categories
    And I see the breadcrumb navigation bar
    Then the first position in the breadcrumb navigation bar is always the home button
    And that button directs me to the main categories

  @rack
  Scenario: Choosing main category
    Given I am listing the main categories
    When I choose a main category
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar

  @hotspot
  Scenario: Choosing a subcategory
    Given I am listing the main categories
    When I choose a subcategory
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar

  @rack
  Scenario: Show the path to a model
    Given I am listing the main categories
    When I choose a main category
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar
    When I open a model
    Then I see the whole path I traversed to get to the model
    And none of the elements of the breadcrumb navigation bar are active

  @rack
  Scenario: Explorative search picks the the category on the first level
    Given I am listing models
    When I pick a first-level category from the results of the explorative search
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar

  @rack
  Scenario: Explorative search: Picking a second-level category
    Given I am listing models
    When I pick a second-level category from the results of the explorative search
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar
