Feature: languages

  @leihs_admin_languages
  Scenario: Listing existing languages
    Given personas dump is loaded
    And I am Gino
    When I visit "/admin/languages"
    Then I see a table of configured languages as follows
      | name          | id      | is_default?  | is_active?  |
      | Castellano    | es      | false        | false       |
      | Deutsch       | de-CH   | false        | true        |
      | English (UK)  | en-GB   | true         | true        |
      | English (US)  | en-US   | false        | true        |
      | Français (CH) | fr-CH   | false        | false       |
      | Züritüütsch   | gsw-CH  | false        | true        |
