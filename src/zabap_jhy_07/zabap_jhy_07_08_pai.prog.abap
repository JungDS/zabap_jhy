*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'LINE'.
      " & 건의 데이터가 검색되었습니다.
      MESSAGE i006 WITH gv_lines.
  ENDCASE.

ENDMODULE.
