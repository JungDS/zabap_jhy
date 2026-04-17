*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_05F01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Form  CONVERT_CALC_OUTPUT
*----------------------------------------------------------------------*
* Perform calc data for screen output
*----------------------------------------------------------------------*
FORM convert_calc_output.

  DATA lv_num1 LIKE gv_result_raw.
  DATA lv_num2 LIKE gv_result_raw.

  SPLIT gv_result_raw AT '.' INTO lv_num1 lv_num2.

  TRY.
      gv_result = |{ CONV int8( lv_num1 ) NUMBER = USER }|.
      IF gv_result_raw CA '.'.
        gv_result = |{ gv_result }.{ lv_num2 }|.
      ENDIF.
      gv_result = |{ gv_result ALIGN = RIGHT WIDTH = 16 }|.
    CATCH cx_root INTO DATA(lx_root).
      MESSAGE lx_root->get_text( ) TYPE 'I'.
  ENDTRY.



ENDFORM.
*----------------------------------------------------------------------*
* Form  REFRESH_CALC
*----------------------------------------------------------------------*
* Refresh calculator
*----------------------------------------------------------------------*
FORM refresh_calc.

  CLEAR: gv_result_raw,
         gv_input,
         gv_input_tmp,
         gv_op_set,
         gv_operator.

ENDFORM.
*----------------------------------------------------------------------*
* Form  CALCULATE_RESULT
*----------------------------------------------------------------------*
* Calculate result of operation
*----------------------------------------------------------------------*
FORM calculate_result.

  CATCH SYSTEM-EXCEPTIONS arithmetic_errors = 4
                          conversion_errors = 8.

    CHECK gv_input_tmp IS NOT INITIAL
      AND gv_input     IS NOT INITIAL.

    CASE gv_operator.
      WHEN 'OP_ADD'.
        gv_input = gv_input_tmp + gv_input.
      WHEN 'OP_SUB'.
        gv_input = gv_input_tmp - gv_input.
      WHEN 'OP_MUL'.
        gv_input = gv_input_tmp * gv_input.
      WHEN 'OP_DIV'.
        IF gv_input EQ 0.
          gv_input = 'DIV/0'.
        ELSE.
          gv_input = gv_input_tmp / gv_input.
        ENDIF.
    ENDCASE.

  ENDCATCH.

  IF sy-subrc <> 0.
*   " 계산할 수 있는 범위를 초과했습니다.
    MESSAGE TEXT-E01 TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  gv_result_raw = gv_input.
  IF gv_result_raw CA '*'.
*   " 계산할 수 있는 범위를 초과했습니다.
    MESSAGE TEXT-E01 TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  CLEAR: gv_input_tmp,gv_op_set.

ENDFORM.
*----------------------------------------------------------------------*
* Form  SET_OPERATION
*----------------------------------------------------------------------*
* Set calculator operation
*----------------------------------------------------------------------*
FORM set_operation.

  IF NOT gv_input_tmp IS INITIAL AND gv_operator EQ ok_code.
    PERFORM calculate_result.
  ENDIF.

  gv_operator    = ok_code.
  gv_op_set      = 'X'.
  gv_input_tmp   = gv_input.

ENDFORM.                               " SET_OPERATION
*----------------------------------------------------------------------*
* Form  CALCULATOR_INPUT
*----------------------------------------------------------------------*
* Function processing for calculator
*----------------------------------------------------------------------*
FORM calculator_input USING pv_input TYPE sy-ucomm.

  IF gv_op_set IS NOT INITIAL.
    CLEAR gv_op_set.
    CLEAR gv_input.
  ENDIF.

  CASE pv_input.
    WHEN '.'.
      IF gv_input CA '.'.
      ELSE.
        gv_input = |{ gv_input }{ pv_input }|.
      ENDIF.
    WHEN OTHERS.
      gv_input = |{ gv_input }{ pv_input }|.
  ENDCASE.

  gv_result_raw = gv_input.


ENDFORM.                               " CALCULATOR_INPUT
*&---------------------------------------------------------------------*
*& Form calculator_memory
*&---------------------------------------------------------------------*
FORM calculator_memory  USING pv_func LIKE sy-ucomm.

  CASE pv_func.
    WHEN 'MC'.
      gv_memory = '0'.
    WHEN 'MR'.
      IF gv_memory IS INITIAL.
        gv_input = '0'.
      ELSE.
        gv_input = gv_memory.
      ENDIF.
      CLEAR gv_op_set.
    WHEN 'M+'.
      ADD gv_input TO gv_memory.
    WHEN 'M-'.
      SUBTRACT gv_input FROM gv_memory.
  ENDCASE.

ENDFORM.
