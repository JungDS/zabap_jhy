*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_CLS
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Class Definition
*--------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.

    METHODS:
      on_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row
                  e_column
                  sender.

ENDCLASS.
*--------------------------------------------------------------------*
* Class Implementation
*--------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.

*    DATA LV_MESSAGE TYPE STRING.
*    LV_MESSAGE = |더블-클릭한 행 번호 { e_row-index }, 열 이름 { e_column-fieldname } 으로 확인됩니다.|.
*    MESSAGE LV_MESSAGE TYPE 'I'.

    PERFORM handle_double_click USING e_row
                                      e_column
                                      sender.

  ENDMETHOD.

ENDCLASS.
