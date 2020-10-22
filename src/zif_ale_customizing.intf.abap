INTERFACE zif_ale_customizing
  PUBLIC .

  METHODS set_scenario
    IMPORTING scenario TYPE zale_config-ale_scenario.

  METHODS get_reader_class
    RETURNING VALUE(reader_class) TYPE REF TO zif_ale_log_reader.

  METHODS get_converter_class
    RETURNING VALUE(converter_class) TYPE REF TO zif_ale_log_converter.

  METHODS get_connector_class
    RETURNING VALUE(connector_class) TYPE REF TO zif_ale_log_connector.

  METHODS get_connector_url
    RETURNING VALUE(connector_url) TYPE zale_config-ale_value.

  DATA scenario TYPE zale_config-ale_scenario READ-ONLY.
  DATA configurations TYPE STANDARD TABLE OF zale_config READ-ONLY.

ENDINTERFACE.
