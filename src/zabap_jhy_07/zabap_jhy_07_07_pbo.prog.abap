*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.

* ALV Grid 예제 2-2 ( 2xClick + Dock. Container )
  SET TITLEBAR  'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0100 OUTPUT.

  IF go_container IS INITIAL.

    PERFORM create_object.
    PERFORM set_alv_layout.
    PERFORM set_alv_fieldcat.
    PERFORM set_alv_event.
    PERFORM set_alv_display_data.

  ELSE.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
