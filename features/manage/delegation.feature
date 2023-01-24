Feature: Delegation

  Scenario: Choosing contact person when handing over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I finish this hand over
    Then I have to specify a contact person

  Scenario: Switching an order from a delegation to a normal user while handing over
    Given I am Pius
    And I open a hand over for a delegation
    When I pick a user instead of a delegation
    Then the hand over shows the user

  Scenario: Switching an order from a normal user to a delegation when handing over
    Given I am Pius
    And I open a hand over
    When I pick a delegation instead of a user
    Then the order shows the delegation

  Scenario: Tooltip display
    Given I am Pius
    When I search for a delegation
    And I hover over the delegation name
    Then the tooltip shows name and responsible person for the delegation

  Scenario: Global search
    Given I am Pius
    And there exists a delegation with 'Julie' in its name
    And Julie is in a delegation
    When I search for 'Julie'
    Then I see all results in the users box for users matching Julie
    And I see all results in delegations box for delegations matching Julie or delegations having members matching Julie

  Scenario: Suspended users can't submit orders
    Given I am Julie
    When I switch from my user to a delegation
    And that delegation is enabled for an inventory pool
    But I am suspended in that inventory pool
    Then I cannot place any reservations in this inventory pool

  Scenario: Filter der Delegationen
    Given I am Pius
    When I can find the user administration features in the "Manage" area under "Users"
    And I am listing users
    Then I can restrict the user list to show only delegations
    And I can restrict the user list to show only users

  Scenario: Switching delegation to a user in an order
    Given I am Pius
    And there is an order for a delegation
    And I edit the order
    When I pick a user instead of a delegation
    Then the order shows the user
    And no contact person is shown

  @unstable
  Scenario: Persönliche Bestellung in Delegationsbestellung ändern in Bestellung
    Given I am Pius
    And I open an order
    When I pick a delegation instead of a user
    And I pick a contact person from the delegation
    And I confirm the user change
    Then the order shows the name of the user
    And the order shows the name of the contact person

  @rack
  Scenario: Listing orders for a delegation
    Given I am Pius
    And there is an order for a delegation
    And I edit the order
    Then I see the delegation's name
    And I see the contact person

  @unstable
  Scenario: Definition of the contact person when creating an order
    Given I am Julie
    When I create an order for a delegation
    Then I am saved as contact person
    Given today corresponds to the start date of the order
    And I am Pius
    When I hand over the items ordered for this delegation to "Mina"
    Then "Mina" is the new contact person for this contract

  @rack
  Scenario: Showing me my own orders
    Given I am Pius
    And there is an order placed by me personally
    And I edit the order
    Then the order shows the name of the user
    And I don't see any contact person

  Scenario: Changing the delegation during hand over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I change the delegation
    And I confirm the user change
    Then the hand over goes to the new delegation

  Scenario: Which delegations are shown when changing during hand over
    Given I am Pius
    And I open a hand over
    When I try to change the delegation
    Then I can choose only those delegations that have access to this inventory pool

  Scenario: Changing contact person during hand over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I try to change the contact person
    Then I can choose only those people that belong to the delegation group

  Scenario: Changing contact person while editing an order
    Given I am Pius
    And I am editing a delegation's order
    When I try to change the order's contact person
    Then I can choose only those people as contact person for the order that belong to the delegation group
    When I choose another contact person for the order
    And I confirm the user change
    Then the contact person for the order has been changed accordingly

  Scenario: Borrow: Creating an order with a delegation
    Given I am Julie
    When I hover over my name
    And I click on "Delegations"
    Then I see the delegations I am assigned to
    When I pick a delegation to represent
    Then I am logged in as that delegation
    Given I am listing models
    When I add an existing model to the order
    Then the calendar opens
    When everything I input into the calendar is valid
    Then the model has been added to the order with the respective start and end date, quantity and inventory pool
    When I open my list of orders
    And I enter a purpose
    And I take note of the reservations
    And I submit the order
    Then the reservations' status changes to submitted
    And the delegation is saved as borrower
    And I am saved as contact person

  Scenario: Changing delegation in an order
    Given I am Pius
    And I open an order
    When I change the delegation
    And I change the contact person
    And I confirm the user change
    Then the hand over goes to the new delegation
    And the newly selected contact person is saved

  Scenario: Which delegations are shown when changing delegation in an order
    Given I am Pius
    And I open an order
    When I try to change the delegation
    Then I can choose only those delegations that have access to this inventory pool

  Scenario: Changing delegation - only one contact person field
    Given I am Pius
    And I am editing a delegation's order
    When I change the delegation
    Then I see exactly one contact person field

  Scenario: Changing delegation - contact person is required
    Given I am Pius
    And I open an order
    When I change the delegation
    And I do not enter any contact person
    And I confirm the user change
    Then an error message pops up saying "Delegated user is not member of the contract's delegation or is empty"
