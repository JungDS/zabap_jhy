*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_PAI
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

    WHEN 'EXEC'.
      PERFORM select_data.
      PERFORM make_display_data.

    WHEN 'TOGGLE'.
      IF gv_dynnr EQ '1100'.
        gv_dynnr = '0200'.
      ELSE.
        gv_dynnr = '1100'.
      ENDIF.

  ENDCASE.

ENDMODULE.
