*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_02_SCR
*&---------------------------------------------------------------------*

* TEXT-S01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

  SELECT-OPTIONS so_car FOR spfli-carrid.
  SELECT-OPTIONS so_con FOR gs_display-connid.

SELECTION-SCREEN END OF BLOCK b01.
