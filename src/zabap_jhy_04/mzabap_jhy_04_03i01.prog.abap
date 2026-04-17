*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_03I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.

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
    WHEN 'RADIO_CLICK'.
      CASE abap_on.
        WHEN scr0100-radio-r1.
          MESSAGE '첫번째 라디오 버튼을 선택했습니다.'(m01) TYPE 'I'.

        WHEN scr0100-radio-r2.
          MESSAGE TEXT-m02 TYPE 'I'.
      ENDCASE.
  ENDCASE.

ENDMODULE.
