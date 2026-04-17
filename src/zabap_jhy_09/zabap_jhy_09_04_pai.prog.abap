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

    WHEN 'RESIZE'.
      CALL SCREEN 0200 STARTING AT 5 10.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE ok_code.
    WHEN 'CONT'.

      go_container->set_extension(
        EXPORTING
          extension  = gv_extension
      ).

      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
