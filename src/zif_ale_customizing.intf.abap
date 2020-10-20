INTERFACE zif_ale_customizing
  PUBLIC .

  METHODS set_scenario
    IMPORTING scenario TYPE zale_config-ale_scenario.

  METHODS get_url
    RETURNING VALUE(url) TYPE zale_config-ale_value.

  DATA scenario TYPE zale_config-ale_scenario READ-ONLY.
  DATA configurations TYPE STANDARD TABLE OF zale_config READ-ONLY.

ENDINTERFACE.
