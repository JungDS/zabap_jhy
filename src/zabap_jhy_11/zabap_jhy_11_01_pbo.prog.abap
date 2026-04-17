*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_01_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " 주변 맛집 가게 등록

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0100 OUTPUT.

  IF go_docking IS INITIAL.
    PERFORM create_object_0100.
    PERFORM set_alv_layout_0100.
    PERFORM set_alv_fieldcat_0100.
    PERFORM set_alv_event_0100.
    PERFORM set_alv_display_0100.
  ELSE.
    IF gv_alv_refresh EQ abap_on.
      PERFORM refresh_alv_grid_0100.

      CLEAR gs_stable.
      CLEAR gv_alv_refresh.
    ENDIF.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_DYNNR_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE fill_dynnr_0100 OUTPUT.

  CASE my_tabstrip-activetab.
    WHEN gc_tabstrip_tab1.
      gv_tabstrip_dynnr = '0110'.
    WHEN gc_tabstrip_tab2.
      gv_tabstrip_dynnr = '0120'.
    WHEN gc_tabstrip_tab3.
      gv_tabstrip_dynnr = '0130'.
    WHEN OTHERS.
      my_tabstrip-activetab = gc_tabstrip_tab1.
      gv_tabstrip_dynnr = '0110'.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen_0110 OUTPUT.

  CHECK gv_complete EQ abap_on.

  LOOP AT SCREEN.
    IF screen-group1 = 'INP'.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen_0120 OUTPUT.

  CHECK gv_complete EQ abap_on.

  LOOP AT SCREEN.
    IF screen-group1 = 'INP'.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_CURSOR_0110 OUTPUT
*&---------------------------------------------------------------------*
MODULE set_cursor_0110 OUTPUT.

  " 이름이 비어있다면 이름부터 입력하도록 커서 이동
  CHECK ZTJHY_shop-shpnm IS INITIAL.

  SET CURSOR FIELD 'ZTJHY_SHOP-SHPNM'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_OBJ_0120 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_obj_0120 OUTPUT.

  PERFORM init_obj_0120.

ENDMODULE.
