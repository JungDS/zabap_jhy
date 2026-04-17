*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_TOP
*&---------------------------------------------------------------------*

TABLES: sscrfields,
        spfli.

DATA: gs_data TYPE spfli,
      gt_data LIKE TABLE OF gs_data.

DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_data.
DATA: END OF gs_display.

DATA: gt_display LIKE TABLE OF gs_display.


*--------------------------------------------------------------------*
* Screen 공용
*--------------------------------------------------------------------*
DATA: ok_code TYPE sy-ucomm.

*--------------------------------------------------------------------*
* Screen 0100
*--------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_docking_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant  TYPE disvariant,
      gv_save     TYPE c VALUE 'A',
      gs_layout   TYPE lvc_s_layo,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,
      gt_sort     TYPE lvc_t_sort,
      gs_sort     TYPE lvc_s_sort.

DATA: gv_lines     TYPE i,
      gv_extension TYPE i value 200.
