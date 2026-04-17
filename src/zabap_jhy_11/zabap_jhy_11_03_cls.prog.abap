*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_03_CLS
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_navigate_complete FOR EVENT navigate_complete OF cl_gui_html_viewer IMPORTING url.
    CLASS-METHODS on_left_click_run FOR EVENT left_click_run OF cl_gui_html_viewer.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_navigate_complete.
*    BREAK-POINT.
    gv_url = url.
    LEAVE SCREEN.
  ENDMETHOD.
  METHOD on_left_click_run.
    BREAK-POINT.
  ENDMETHOD.
ENDCLASS.
