*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_04_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR  '0100'. " [ CODE 대학교 ] 신입생 / 전입생 등록화면
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.

* 학번이 존재하면 생성이 완료된 생태라 볼 수 있다.
  CHECK ztjhy_student-stdid IS NOT INITIAL.

" (INP) 인풋 필드와 저장버튼을 전부 읽기전용으로 변경한다.
  LOOP AT SCREEN.
    IF screen-group1 EQ 'INP'. " INP: INPUT FIELD
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.

    IF SCREEN-NAME EQ 'BUTTON_SAVE'.
      SCREEN-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.
