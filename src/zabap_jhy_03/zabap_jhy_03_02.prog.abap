*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_02
*&---------------------------------------------------------------------*
*& Selection Screen Block 활용
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_02.



DATA GS_SFLIGHT TYPE SFLIGHT.

*--------------------------------------------------------------------*
* Frame이 없는 Block
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B01 .
  PARAMETERS     PA_CAR1 TYPE SCARR-CARRID.
  SELECT-OPTIONS SO_CON1 FOR  GS_SFLIGHT-CONNID.
SELECTION-SCREEN END OF BLOCK B01.

* 비어있는 줄 추가
SELECTION-SCREEN SKIP.

*--------------------------------------------------------------------*
* Frame이 있는 Block
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME.
  PARAMETERS     PA_CAR2 TYPE SCARR-CARRID.
  SELECT-OPTIONS SO_CON2 FOR  GS_SFLIGHT-CONNID.
SELECTION-SCREEN END OF BLOCK B02.

* 비어있는 2줄 추가
SELECTION-SCREEN SKIP 2.

*--------------------------------------------------------------------*
* Frame과 Title이 있는 Block
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME TITLE TEXT-T01. " TITLE of Selection Screen Block
  PARAMETERS     PA_CAR3 TYPE SCARR-CARRID.
  SELECT-OPTIONS SO_CON3 FOR  GS_SFLIGHT-CONNID.
SELECTION-SCREEN END OF BLOCK B03.
