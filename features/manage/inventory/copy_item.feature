
Feature: Copy item

  Background:
    Given I am Mike

  Scenario: Create and copy items
    Given I create an item
    And I choose "Investment"
    And I make a note of the original inventory code
    And I enter the following item information
      | field                  | type         | value               |
      | Borrowable             | radio        | OK                  |
      # FIX: IS BROKEN ON CIDER!!!
      | Building               | autocomplete | general building  |
      | Check-In Date          |              | 01/01/2013          |
      | Check-In Note          |              | Test note           |
      | Check-In State         | select       | transportschaden    |
      | Completeness           | radio        | OK                  |
      | Contract expiration    |              | 01/01/2013          |
      | IMEI-Number            |              | Test IMEI number    |
      | Initial Price          |              | 50.00               |
      | Invoice Date           |              | 01/01/2013          |
      | Invoice Number         |              | Test number         |
      | Last Checked           |              | 01/01/2013          |
      | MAC-Address            |              | Test MAC address    |
      | Model                  | autocomplete | Sharp Beamer 456    |
      | Move                   | select       | sofort entsorgen    |
      | Name                   |              | Test name           |
      | Note                   |              | Test note           |
      | Project Number         |              | Test number         |
      | Relevant for inventory | select       | Yes                 |
      | Responsible department | autocomplete | A-Ausleihe          |
      | Responsible person     |              | Matus Kmit          |
      | Retirement             | checkbox     | unchecked           |
      # FIX: IS BROKEN ON CIDER!!!
      | Room                   | autocomplete | general room      |
      | Serial Number          |              | Test serial number  |
      | Shelf                  |              | Test shelf          |
      | Target area            |              | Test room           |
      | User/Typical usage     |              | Test use            |
      | Warranty expiration    |              | 01/01/2013          |
      | Working order          | radio        | OK                  |
    When I save and copy
    Then the item is saved
    And I can create a new item
    And I can cancel
    And all fields except the following were copied:
    | Inventory Code |
    | Name           |
    | Serial Number  |
    | Last Checked   |
    And the inventory code is already filled in
    And the last check date is set to today
    When I save
    Then the copied item is saved
    And I am redirected to the inventory list

  Scenario: Copying an item selected from a list
    Given I open the inventory
    When I copy an item
    Then an item copy screen is shown
    And all fields except inventory code, serial number and name are copied
    And the last check date is set to today

  Scenario: Copying an item from the edit view
    When I am editing an item
    And I save and copy
    Then an item copy screen is shown
    And all fields except inventory code, serial number and name are copied
    And the last check date is set to today

  Scenario: Copying an item from another inventory pool
    Given I log out
    And I am Matti
    And I edit an item belonging to a different inventory pool
    And I save and copy
    Then an item copy screen is shown
    And all fields are editable, because the current inventory pool owns this new item
