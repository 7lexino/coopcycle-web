Feature: Pricing

  Scenario: Get delivery price with JWT
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing/deliveries" with body:
      """
      {
        "store":"/api/stores/1",
        "pickup": {
          "address": "24, Rue de la Paix Paris",
          "before": "tomorrow 13:00"
        },
        "dropoff": {
          "address": "48, Rue de Rivoli Paris",
          "before": "tomorrow 15:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":"/api/contexts/Pricing",
        "@id":@string@,
        "@type":"Pricing",
        "id":@string@,
        "price":499,
        "currencyCode":"EUR"
      }
      """

  Scenario: Get delivery price with packages (JWT)
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing/deliveries" with body:
      """
      {
        "store":"/api/stores/3",
        "packages": [
          {"type": "XL", "quantity": 2}
        ],
        "pickup": {
          "address": "24, Rue de la Paix Paris",
          "before": "tomorrow 13:00"
        },
        "dropoff": {
          "address": "48, Rue de Rivoli Paris",
          "before": "tomorrow 15:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":"/api/contexts/Pricing",
        "@id":@string@,
        "@type":"Pricing",
        "id":@string@,
        "price":1299,
        "currencyCode":"EUR"
      }
      """

  Scenario: Get delivery price with latlLng (JWT)
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing/deliveries" with body:
      """
      {
        "store":"/api/stores/1",
        "weight": 12000,
        "packages": [
          {"type": "SMALL", "quantity": 2}
        ],
        "pickup": {
          "address": {
            "streetAddress": "24, Rue de la Paix Paris",
            "latLng": [48.870134, 2.332221]
          },
          "before": "tomorrow 13:00"
        },
        "dropoff": {
          "address": {
            "streetAddress": "48, Rue de Rivoli Paris",
            "latLng": [48.857127, 2.354766]
          },
          "before": "tomorrow 15:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":"/api/contexts/Pricing",
        "@id":@string@,
        "@type":"Pricing",
        "id":@string@,
        "price":499,
        "currencyCode":"EUR"
      }
      """

  Scenario: Evaluate pricing rule (JWT)
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing_rules/1/evaluate" with body:
      """
      {
        "pickup": {
          "address": {
            "streetAddress": "24, Rue de la Paix Paris",
            "latLng": [48.870134, 2.332221]
          },
          "before": "tomorrow 13:00"
        },
        "dropoff": {
          "address": {
            "streetAddress": "48, Rue de Rivoli Paris",
            "latLng": [48.857127, 2.354766]
          },
          "before": "tomorrow 15:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":{
          "@vocab":@string@,
          "hydra":@string@,
          "result":"YesNoOutput/result"
        },
        "@type":"YesNoOutput",
        "@id":@string@,
        "result":true
      }
      """

  Scenario: Evaluate pricing rule (JWT)
    Given the current time is "2020-06-09 12:00:00"
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing_rules/2/evaluate" with body:
      """
      {
        "pickup": {
          "address": {
            "streetAddress": "24, Rue de la Paix Paris",
            "latLng": [48.870134, 2.332221]
          },
          "timeSlot": "2020-06-09 17:00-18:00"
        },
        "dropoff": {
          "address": {
            "streetAddress": "48, Rue de Rivoli Paris",
            "latLng": [48.857127, 2.354766]
          },
          "timeSlot": "2020-06-09 17:00-18:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":{
          "@vocab":@string@,
          "hydra":@string@,
          "result":"YesNoOutput/result"
        },
        "@type":"YesNoOutput",
        "@id":@string@,
        "result":false
      }
      """

  Scenario: Evaluate pricing rule (JWT)
    Given the current time is "2020-06-09 12:00:00"
    Given the fixtures files are loaded:
      | sylius_channels.yml |
      | stores.yml          |
    And the user "admin" is loaded:
      | email      | admin@coopcycle.org |
      | password   | 123456            |
    And the user "admin" has role "ROLE_ADMIN"
    And the user "admin" is authenticated
    When I add "Content-Type" header equal to "application/ld+json"
    And I add "Accept" header equal to "application/ld+json"
    And the user "admin" sends a "POST" request to "/api/pricing_rules/3/evaluate" with body:
      """
      {
        "packages": [
          {"type": "XL", "quantity": 2}
        ],
        "pickup": {
          "address": {
            "streetAddress": "24, Rue de la Paix Paris",
            "latLng": [48.870134, 2.332221]
          },
          "timeSlot": "2020-06-09 17:00-18:00"
        },
        "dropoff": {
          "address": {
            "streetAddress": "48, Rue de Rivoli Paris",
            "latLng": [48.857127, 2.354766]
          },
          "timeSlot": "2020-06-09 17:00-18:00"
        }
      }
      """
    Then the response status code should be 200
    And the response should be in JSON
    And the JSON should match:
      """
      {
        "@context":{
          "@vocab":@string@,
          "hydra":@string@,
          "result":"YesNoOutput/result"
        },
        "@type":"YesNoOutput",
        "@id":@string@,
        "result":true
      }
      """
