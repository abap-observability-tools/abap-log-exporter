CLASS zcl_ale_customizing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_customizing.

    CONSTANTS: BEGIN OF customzing_fields,
                 reader_class    TYPE zale_config-ale_key VALUE 'RDR_CLASS',
                 converter_class TYPE zale_config-ale_key VALUE 'CVTR_CLASS',
                 connector_url   TYPE zale_config-ale_key VALUE 'CNCTR_URL',
                 connector_class TYPE zale_config-ale_key VALUE 'CNCTR_CLAS',
               END OF customzing_fields.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_ale_customizing IMPLEMENTATION.

  METHOD zif_ale_customizing~set_scenario.

    zif_ale_customizing~scenario = scenario.

    SELECT *
    FROM zale_config
    INTO TABLE @zif_ale_customizing~configurations
    WHERE ale_scenario = @zif_ale_customizing~scenario.

  ENDMETHOD.

  METHOD zif_ale_customizing~get_connector_class.
    DATA(connector_class_name) = zif_ale_customizing~configurations[ ale_key = customzing_fields-connector_class ]-ale_value.
    TRANSLATE connector_class_name TO UPPER CASE.
    CREATE OBJECT connector_class TYPE (connector_class_name).
  ENDMETHOD.

  METHOD zif_ale_customizing~get_connector_url.
    connector_url = zif_ale_customizing~configurations[ ale_key = customzing_fields-connector_url ]-ale_value.
  ENDMETHOD.

  METHOD zif_ale_customizing~get_converter_class.
    DATA(converter_class_name) = zif_ale_customizing~configurations[ ale_key = customzing_fields-converter_class ]-ale_value.
    TRANSLATE converter_class_name TO UPPER CASE.
    CREATE OBJECT converter_class TYPE (converter_class_name).
  ENDMETHOD.

  METHOD zif_ale_customizing~get_reader_class.
    DATA(reader_class_name) = zif_ale_customizing~configurations[ ale_key = customzing_fields-reader_class ]-ale_value.
    TRANSLATE reader_class_name TO UPPER CASE.
    CREATE OBJECT reader_class TYPE (reader_class_name).
  ENDMETHOD.

ENDCLASS.
