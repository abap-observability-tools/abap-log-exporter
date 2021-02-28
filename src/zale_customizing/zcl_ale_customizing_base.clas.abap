CLASS zcl_ale_customizing_base DEFINITION INHERITING FROM zcl_ale_customizing
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_reader_class REDEFINITION.
    METHODS get_converter_class REDEFINITION.
    METHODS get_connector_class REDEFINITION.
    METHODS get_connector_url REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_ale_customizing_base IMPLEMENTATION.
  METHOD get_connector_class.
    DATA(connector_class_name) = configuration-connector_class.
    TRANSLATE connector_class_name TO UPPER CASE.
    CREATE OBJECT connector_class TYPE (connector_class_name).
  ENDMETHOD.

  METHOD get_connector_url.
    connector_url = configuration-connector_url.
  ENDMETHOD.

  METHOD get_converter_class.
    DATA(converter_class_name) = configuration-converter_class.
    TRANSLATE converter_class_name TO UPPER CASE.
    CREATE OBJECT converter_class TYPE (converter_class_name).
  ENDMETHOD.

  METHOD get_reader_class.
    DATA(reader_class_name) = configuration-reader_class.
    TRANSLATE reader_class_name TO UPPER CASE.
    CREATE OBJECT reader_class TYPE (reader_class_name).
  ENDMETHOD.

ENDCLASS.
