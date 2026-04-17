*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_03_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'. " Chat GPT 띄우기
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_HTML_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_html_0100 OUTPUT.

  IF go_html IS INITIAL.
    PERFORM create_object_0100.
    perform set_html_event_0100.
    PERFORM show_html_0100.
  ELSE.
    go_html->get_current_url( IMPORTING url = gv_url ).
  ENDIF.

ENDMODULE.
