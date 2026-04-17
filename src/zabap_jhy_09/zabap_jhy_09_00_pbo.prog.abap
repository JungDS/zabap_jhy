*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.  " Chart Engine ( 직접 설정 )

ENDMODULE. " STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*& Module INIT_CHART_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_chart_0100 OUTPUT.

  IF go_container IS INITIAL.

    PERFORM create_object_0100.

    PERFORM set_chart_event_0100.

    PERFORM set_chart_custom_0100.
    PERFORM set_chart_data_0100.


    CALL METHOD go_chart_engine->render.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
