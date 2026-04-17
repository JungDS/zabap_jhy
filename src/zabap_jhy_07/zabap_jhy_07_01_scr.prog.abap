*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_01_SCR
*&---------------------------------------------------------------------*


" TEXT-S01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

  SELECT-OPTIONS so_car FOR scarr-carrid.

SELECTION-SCREEN END OF BLOCK b01.
