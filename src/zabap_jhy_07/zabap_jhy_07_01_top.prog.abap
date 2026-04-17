*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_01_TOP
*&---------------------------------------------------------------------*

TABLES: scarr.

DATA gt_scarr       TYPE TABLE OF scarr.

DATA go_container   TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid    TYPE REF TO cl_gui_alv_grid.


DATA ok_code TYPE sy-ucomm.
