Feature: Show common information for tooling

  Scenario: Show general help
    When I run `product-type-generator`
    Then the exit status should be 1
    And the output should contain:
    """
    Usage:
    """

  Scenario: Show general help
    When I run `product-type-generator --attributes ../../data/tests/product-types-attributes-all.csv --types ../../data/tests/product-types.csv --target .`
    Then the exit status should be 0
    And the output should contain:
    """
    About to read files...
    Running generator...
    """
    And the output should contain:
    """
    About to write files...
    Generated 8 files for normal product-types
    Finished generating files, checking results in target folder: .
    Found 8 files in target folder .
    Execution successfully finished
    """
    Then a file named "product-type-boo-txt-num.json" should exist
    And the file "product-type-boo-txt-num.json" should contain:
    """
        {
          "name": "LocTextCFF",
          "label": {
            "de": "Lokalisierter Text",
            "en": "Localizable Text"
          },
          "type": {
            "name": "ltext"
          },
          "attributeConstraint": "CombinationUnique",
          "isRequired": false,
          "isSearchable": false,
          "inputHint": "SingleLine"
        },
    """
    When I run `product-type-update --projectKey producttype-json-generator-tests --source product-type-boo-txt-num.json`
    #Then the exit status should be 0
    And the output should contain:
    """
    Product Types successfully posted to SPHERE.IO
    """
