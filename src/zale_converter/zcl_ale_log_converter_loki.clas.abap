CLASS zcl_ale_log_converter_loki DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_log_converter.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ale_log_converter_loki IMPLEMENTATION.
  METHOD zif_ale_log_converter~convert.

    LOOP AT logs ASSIGNING FIELD-SYMBOL(<log>).

      DATA(object) = <log>-additional_fields[ field = 'object' ]-value.

      DATA(loki_json) = |\{"streams": | &&
                        |[| &&
                        |\{ "labels": "\{ object=\\"{ object }\\" \}",| &&
                        |"entries": [| &&
                        |\{ "ts": "{ <log>-timestamp TIMESTAMP = ISO }Z", "line": "{ <log>-item_text }" \}| &&
                        |] \}]\}|.

      converted_logs = VALUE #( BASE converted_logs ( json = loki_json ) ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
