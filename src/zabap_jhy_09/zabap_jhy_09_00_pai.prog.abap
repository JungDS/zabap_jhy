*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_PAI
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
    WHEN 'DESIGN'.
      PERFORM toggle_design_mode.
    WHEN 'VALUE'.
      PERFORM toggle_value_change.
    WHEN 'SAVE'.
      PERFORM save_customizing.
    WHEN 'PRINT'.
      PERFORM print.
  ENDCASE.

ENDMODULE. " USER_COMMAND_0100 INPUT
