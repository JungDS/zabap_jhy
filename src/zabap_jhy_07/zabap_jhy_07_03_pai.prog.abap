*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_PAI
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.      " 현재 프로그램 종료

    WHEN 'CANC'.
      LEAVE TO SCREEN 0.  " 현재 화면 종료하고 이전 화면으로 이동
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.  " 현재 화면 종료하고 이전 화면으로 이동

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_CARRID  INPUT
*&---------------------------------------------------------------------*
MODULE f4_carrid INPUT.

*  message '만들 예정입니다.' type 'I'.

  DATA lt_return TYPE TABLE OF ddshretval.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CARRID'                 " Name of return field in FIELD_TAB
      value_org       = 'S'              " Value return: C: cell by cell, S: structured
      ddic_structure  = 'SCARR'            " Structure of VALUE_TAB (VALUE_ORG = 'S')
      window_title    = '항공사를 선택하세요'                 " Title for the hit list
*     pvalkey         = space            " Key for personal help
*     dynpprog        = space            " Current program
*     dynpnr          = space            " Screen number
*     dynprofield     = space            " Name of screen field for value return
*     stepl           = 0                " Steploop line of screen field
*     value           = space            " Field contents for F4 call
*     multiple_choice = space            " Switch on multiple selection
*     display         = space            " Override readiness for input
*     callback_program = space            " Program for callback before F4 start
*     callback_form   = space            " Form for callback before F4 start (-> long docu)
*     callback_method =                  " Interface for Callback Routines
*     mark_tab        =                  " Defaults for Selected Lines when Multiple Selection is Switched On
    TABLES
      value_tab       = gt_carr                 " Table of values: entries cell by cell
*     field_tab       =                  " Fields of the hit list
      return_tab      = lt_return                 " Return the selected value
*     dynpfld_mapping =                  " Assignment of the screen fields to the internal table
    EXCEPTIONS
      parameter_error = 1                " Incorrect parameter
      no_values_found = 2                " No values found
      OTHERS          = 3.

*  BREAK-POINT.

  READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
  IF sy-subrc EQ 0.
    READ TABLE gt_carr INTO gs_carr WITH TABLE KEY carrid = ls_return-fieldval.

    IF gs_carr-currcode EQ 'USD'.
      scarr = CORRESPONDING #( gs_carr ).
    ELSE.
      MESSAGE '달러를 취급하는 항공사만 선택하세요.' TYPE 'I' DISPLAY LIKE 'E'.
      CLEAR scarr.
    ENDIF.
    LEAVE SCREEN .

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_CARRID  INPUT
*&---------------------------------------------------------------------*
MODULE check_carrid INPUT.

  READ TABLE gt_carr INTO gs_carr WITH TABLE KEY carrid = scarr-carrid.

  IF gs_carr-currcode EQ 'USD'.
    scarr = CORRESPONDING #( gs_carr ).
  ELSE.
    MESSAGE '달러를 취급하는 항공사만 선택하세요.' TYPE 'E'.
    CLEAR scarr.
  ENDIF.

ENDMODULE.
