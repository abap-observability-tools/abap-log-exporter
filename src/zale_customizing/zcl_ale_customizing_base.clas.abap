CLASS zcl_ale_customizing_base DEFINITION INHERITING FROM zcl_ale_customizing
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS: BEGIN OF customzing_fields,
                 reader_class    TYPE zale_config-ale_key VALUE 'RDR_CLASS',
                 converter_class TYPE zale_config-ale_key VALUE 'CVTR_CLASS',
                 connector_url   TYPE zale_config-ale_key VALUE 'CNCTR_URL',
                 connector_class TYPE zale_config-ale_key VALUE 'CNCTR_CLAS',
               END OF customzing_fields.

    METHODS get_reader_class REDEFINITION.
    METHODS get_converter_class REDEFINITION.
    METHODS get_connector_class REDEFINITION.
    METHODS get_connector_url REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_ale_customizing_base IMPLEMENTATION.
  METHOD get_connector_class.
    DATA(connector_class_name) = configurations[ ale_key = customzing_fields-connector_class ]-ale_value.
    TRANSLATE connector_class_name TO UPPER CASE.
    CREATE OBJECT connector_class TYPE (connector_class_name).
  ENDMETHOD.

  METHOD get_connector_url.
    connector_url = configurations[ ale_key = customzing_fields-connector_url ]-ale_value.
  ENDMETHOD.

  METHOD get_converter_class.
    DATA(converter_class_name) = configurations[ ale_key = customzing_fields-converter_class ]-ale_value.
    TRANSLATE converter_class_name TO UPPER CASE.
    CREATE OBJECT converter_class TYPE (converter_class_name).
  ENDMETHOD.

  METHOD get_reader_class.
    DATA(reader_class_name) = configurations[ ale_key = customzing_fields-reader_class ]-ale_value.
    TRANSLATE reader_class_name TO UPPER CASE.
    CREATE OBJECT reader_class TYPE (reader_class_name).
  ENDMETHOD.

ENDCLASS.
