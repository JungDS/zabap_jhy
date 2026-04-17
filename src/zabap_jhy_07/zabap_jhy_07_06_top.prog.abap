*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_06_TOP
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Dictionary Structure
*--------------------------------------------------------------------*
TABLES sscrfields.
TABLES scarr.


*--------------------------------------------------------------------*
* Constants
*--------------------------------------------------------------------*
CONSTANTS: gc_custctrl_name           TYPE char30   VALUE 'CCON',

           gc_msgty_success           TYPE c        VALUE 'S',
           gc_msgty_warning           TYPE c        VALUE 'W',
           gc_msgty_error             TYPE c        VALUE 'E',

           gc_variant_save_mode_all   TYPE c        VALUE 'A',
           gc_variant_save_mode_user  TYPE c        VALUE 'U',
           gc_variant_save_mode_cross TYPE c        VALUE 'X',

           gc_text_align_center       TYPE c        VALUE 'C',
           gc_text_align_left         TYPE c        VALUE 'L',
           gc_text_align_right        TYPE c        VALUE 'R',

           gc_color_yellow_light      TYPE char4    VALUE 'C300',
           gc_color_green_light       TYPE char4    VALUE 'C500'.


*--------------------------------------------------------------------*
* Global Variables ( Elementary, Structure, Internal Table )
*--------------------------------------------------------------------*
DATA: gs_carr TYPE scarr.
DATA: gt_carr LIKE TABLE OF gs_carr.

DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_carr.
DATA: END OF gs_display.
DATA gt_display LIKE TABLE OF gs_display.

DATA gv_lines TYPE i.

*--------------------------------------------------------------------*
* ALV 관련 변수(Variables)
*--------------------------------------------------------------------*
DATA go_container TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

DATA gs_variant TYPE disvariant.
DATA gv_save TYPE c.
DATA gs_layout TYPE lvc_s_layo.

* 추가된 부분
DATA gt_fieldcat TYPE lvc_t_fcat.

*--------------------------------------------------------------------*
* Screen과 통신용 변수
*--------------------------------------------------------------------*
DATA ok_code TYPE sy-ucomm.
