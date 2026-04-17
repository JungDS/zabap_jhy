*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_SCR
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Screen 1000
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.
* - Prefix 정의
*   1. PA_  : Parameters (checkbox, radiobutton... )
*   2. SO_  : Selection-options
* EX) PARAMETER: PA_DATUM TYPE DATUM DEFAULT SY-DATUM OBLIGATORY.

  SELECT-OPTIONS: so_carr FOR sflight-carrid.

*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT (30) tx_radio.

    SELECTION-SCREEN POSITION POS_LOW.
    PARAMETERS ra_struc RADIOBUTTON GROUP rg1.
    SELECTION-SCREEN COMMENT (60) tx_struc FOR FIELD ra_struc.
  SELECTION-SCREEN END OF LINE.
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN POSITION POS_LOW.
    PARAMETERS ra_direc RADIOBUTTON GROUP rg1.
    SELECTION-SCREEN COMMENT (60) tx_direc FOR FIELD ra_direc.
  SELECTION-SCREEN END OF LINE.
*--------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN POSITION POS_LOW.
    PARAMETERS ra_func RADIOBUTTON GROUP rg1.
    SELECTION-SCREEN COMMENT (60) tx_func FOR FIELD ra_func.
  SELECTION-SCREEN END OF LINE.
*--------------------------------------------------------------------*
SELECTION-SCREEN: END OF BLOCK b01.
