*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_SCR
*&---------------------------------------------------------------------*

* TEXT-S01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

  SELECT-OPTIONS s_carrid FOR scarr-carrid.
  SELECT-OPTIONS s_carrnm FOR scarr-carrname.
  SELECT-OPTIONS s_currcd FOR scarr-currcode.

SELECTION-SCREEN END OF BLOCK b01.
