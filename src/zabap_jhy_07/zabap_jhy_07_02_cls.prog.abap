*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_02_CLS
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Class (Definition) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id
                e_column_id
                sender.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_hotspot_click.

    DATA lv_msgv1 TYPE text50.
    DATA lv_msgv2 TYPE text50.
    DATA lv_msgv3 TYPE text50.
    DATA lv_msgv4 TYPE text50.

    lv_msgv1 = |선택하신 행 번호는 { e_row_id-index } 이고,|.
    lv_msgv2 = |열 이름은 { e_column_id-fieldname } 입니다. |.
    lv_msgv3 = ''.
    lv_msgv4 = ''.

    MESSAGE i000 WITH lv_msgv1
                      lv_msgv2
                      lv_msgv3
                      lv_msgv4.

  ENDMETHOD.
ENDCLASS.
