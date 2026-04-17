*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_05I01
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
    WHEN 'CLEAR'.
      PERFORM refresh_calc.
    WHEN 'CALC'.
      PERFORM calculate_result.
    WHEN 'OP_ADD' OR 'OP_SUB' OR 'OP_MUL' OR 'OP_DIV'.
      PERFORM set_operation.
    WHEN 'MR' OR 'M+' OR 'M-' OR 'MC'.
      PERFORM calculator_memory USING ok_code.
    WHEN OTHERS.
      PERFORM calculator_input USING ok_code.
  ENDCASE.

ENDMODULE.
