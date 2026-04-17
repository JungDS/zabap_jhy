*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_SCR
*&---------------------------------------------------------------------*


* TEXT-S01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-S01.

  SELECT-OPTIONS: so_car    FOR sdyn_book-carrid,
                  so_con    FOR sdyn_book-connid,
                  so_spmon  FOR gv_spmon NO-EXTENSION.

*  PARAMETERS: pa_year TYPE gjahr OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
