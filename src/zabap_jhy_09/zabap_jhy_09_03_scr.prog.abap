*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_SCR
*&---------------------------------------------------------------------*

* TEXT-S01 : Selection Options
* TEXT-S02 : Departure Options
* TEXT-S03 : Destination Options ( No Intervals 옵션 적용 )

SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
**SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.
  SELECT-OPTIONS: so_car FOR spfli-carrid,
                  so_con FOR spfli-connid.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-s02.
    SELECT-OPTIONS: so_cntf FOR spfli-countryfr,
                    so_citf FOR spfli-cityfrom,
                    so_airf FOR spfli-airpfrom.
  SELECTION-SCREEN END OF BLOCK b02 .

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-s03 NO INTERVALS.
    SELECT-OPTIONS: so_cntt FOR spfli-countryto,
                    so_citt FOR spfli-cityto,
                    so_airt FOR spfli-airpto.
  SELECTION-SCREEN END OF BLOCK b03.

**SELECTION-SCREEN END OF BLOCK b01.
SELECTION-SCREEN END OF SCREEN 1100.
