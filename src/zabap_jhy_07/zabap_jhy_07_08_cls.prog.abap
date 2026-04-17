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
                  sender,

      on_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object
                  sender,

      on_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm
                  sender.

ENDCLASS.

*--------------------------------------------------------------------*
* Class Implementation
*--------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.

    PERFORM handle_double_click USING e_row
                                      e_column
                                      sender.

  ENDMETHOD.

  METHOD on_toolbar.

    PERFORM handle_toolbar USING e_object
                                 sender.

  ENDMETHOD.

  METHOD on_user_command.

    PERFORM handle_user_command USING e_ucomm
                                      sender.

  ENDMETHOD.

ENDCLASS.
