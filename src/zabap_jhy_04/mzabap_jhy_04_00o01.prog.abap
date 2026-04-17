*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_00O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'S0100'.

  " [M] Simple Screen Element 연습, &
  SET TITLEBAR  'T0100' WITH sy-uname.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ICON_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE set_icon_0100 OUTPUT.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = 'ICON_LED_GREEN'     " Icon name  (Name from INCLUDE <ICON> )
      text                  = '초록색 LED 아이콘'  " Icon text (shown behind)
    IMPORTING
      result                = iconfield1           " Icon (enter the screen field here)
    EXCEPTIONS
      icon_not_found        = 1  " Icon name unknown to system
      outputfield_too_short = 2  " Length of field 'RESULT' is too small
      OTHERS                = 3.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = 'ICON_LED_YELLOW'     " Icon name  (Name from INCLUDE <ICON> )
      text                  = '노란색 LED 아이콘'  " Icon text (shown behind)
    IMPORTING
      result                = iconfield2           " Icon (enter the screen field here)
    EXCEPTIONS
      icon_not_found        = 1  " Icon name unknown to system
      outputfield_too_short = 2  " Length of field 'RESULT' is too small
      OTHERS                = 3.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = 'ICON_LED_RED'     " Icon name  (Name from INCLUDE <ICON> )
      text                  = '빨간색 LED 아이콘'  " Icon text (shown behind)
    IMPORTING
      result                = iconfield3           " Icon (enter the screen field here)
    EXCEPTIONS
      icon_not_found        = 1  " Icon name unknown to system
      outputfield_too_short = 2  " Length of field 'RESULT' is too small
      OTHERS                = 3.

ENDMODULE.
