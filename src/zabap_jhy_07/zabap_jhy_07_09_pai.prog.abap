*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.

*-- OK_CODE
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CLEAR: gv_answer, gv_error.

  CASE ok_code.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE'.

      "-- ALV 화면에 입력된 데이터 점검 및 Itab으로 전송
      CALL METHOD go_grid->check_changed_data( ).

      "-- Itab의 내용 점검
      PERFORM checked_saved_data.

      CHECK gv_error IS INITIAL.

      "-- Popup to confirm
      PERFORM popup_to_confirm.

      CHECK gv_answer EQ '1'.

      "-- Save data
      PERFORM save_data_rtn.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
