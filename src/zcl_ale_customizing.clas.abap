CLASS zcl_ale_customizing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_ale_customizing.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_ale_customizing IMPLEMENTATION.

  METHOD zif_ale_customizing~get_url.
    url = zif_ale_customizing~configurations[ ale_key = 'URL' ]-ale_value.
  ENDMETHOD.

  METHOD zif_ale_customizing~set_scenario.

    zif_ale_customizing~scenario = scenario.

    SELECT *
    FROM zale_config
    INTO TABLE @zif_ale_customizing~configurations
    WHERE ale_scenario = @zif_ale_customizing~scenario.

  ENDMETHOD.

ENDCLASS.
