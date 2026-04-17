*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_04_SCR
*&---------------------------------------------------------------------*

* TEXT-T01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

* 항공사 ID 만 필수 입력으로 받음
  PARAMETERS pa_car TYPE sflight-carrid OBLIGATORY MEMORY ID CAR.

SELECTION-SCREEN END OF BLOCK b01.
