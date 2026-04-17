*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_01O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

* Function Code: BACK, EXIT, CANC
  SET PF-STATUS 'S0100'.

* [M] Modify Screen 연습, &
  CASE gv_mode.
    WHEN 0.
      SET TITLEBAR  'T0100' WITH '조회모드'(t01) sy-uname.

    WHEN 1.
      SET TITLEBAR  'T0100' WITH '수정모드'(t02) sy-uname.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.

  LOOP AT SCREEN.
    " 입력필드는 FIELD_A & FIELD_B
    CASE screen-name.
      WHEN 'FIELD_A'. screen-input = gv_mode.
      WHEN 'FIELD_B'. screen-input = gv_mode.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.
