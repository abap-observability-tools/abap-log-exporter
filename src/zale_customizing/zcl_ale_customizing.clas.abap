CLASS zcl_ale_customizing DEFINITION PUBLIC ABSTRACT.
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING scenario TYPE zale_config-log_scenario.

    METHODS get_reader_class ABSTRACT
      RETURNING VALUE(reader_class) TYPE REF TO zif_ale_log_reader.

    METHODS get_converter_class ABSTRACT
      RETURNING VALUE(converter_class) TYPE REF TO zif_ale_log_converter.

    METHODS get_connector_class ABSTRACT
      RETURNING VALUE(connector_class) TYPE REF TO zif_ale_log_connector.

    METHODS get_connector_url ABSTRACT
      RETURNING VALUE(connector_url) TYPE zale_config-connector_url.

  PROTECTED SECTION.

    DATA scenario TYPE zale_config-log_scenario.
    DATA configuration TYPE zale_config.

  PRIVATE SECTION.

    METHODS set_scenario
      IMPORTING scenario TYPE zale_config-log_scenario.

ENDCLASS.

CLASS zcl_ale_customizing IMPLEMENTATION.
  METHOD constructor.

    me->set_scenario( scenario ).

  ENDMETHOD.

  METHOD set_scenario.

    me->scenario = scenario.

    SELECT SINGLE *
      FROM zale_config
      INTO @configuration
      WHERE log_scenario = @scenario.

  ENDMETHOD.

ENDCLASS.
