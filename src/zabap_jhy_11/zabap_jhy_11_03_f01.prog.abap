*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_03_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_ccon
    EXPORTING
      container_name = 'CCON'.

  CREATE OBJECT go_html
    EXPORTING
      parent = go_ccon                 " Container
    EXCEPTIONS
      OTHERS = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_HTML_0100
*&---------------------------------------------------------------------*
FORM show_html_0100 .

  go_html->show_url( url      = gv_url
                     frame    = abap_on
                     in_place = abap_on ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_html_event_0100
*&---------------------------------------------------------------------*
FORM set_html_event_0100 .


  SET HANDLER lcl_event_handler=>on_navigate_complete FOR go_html.
  SET HANDLER lcl_event_handler=>on_left_click_run    FOR go_html.

  DATA lt_events TYPE cntl_simple_events.
  go_html->get_registered_events( IMPORTING events = lt_events ).

  lt_events = VALUE #( BASE lt_events ( eventid = cl_gui_html_viewer=>m_id_navigate_complete ) ).

  go_html->set_registered_events( EXPORTING events = lt_events ).


  DATA lv_url_method(8).

  lv_url_method = to_upper( gv_url(8) ).

  IF NOT ( lv_url_method(7) EQ 'HTTP://' OR lv_url_method(8) EQ 'HTTPS://' ).

    gv_url = |https://{ gv_url ALPHA = out }|.

  ENDIF.

ENDFORM.
