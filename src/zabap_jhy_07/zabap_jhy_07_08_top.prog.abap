*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_TOP
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Dictionary Structure
*--------------------------------------------------------------------*
TABLES sscrfields.
TABLES scarr.

*--------------------------------------------------------------------*
* Class Definition Deferred
*--------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION DEFERRED.


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
           gc_color_green_light       TYPE char4    VALUE 'C500',

           gc_toolbar_button_fc_close TYPE ui_func  VALUE 'CLOSE'.


*--------------------------------------------------------------------*
* Global Variables ( Elementary, Structure, Internal Table )
*--------------------------------------------------------------------*
DATA: gs_carr TYPE scarr.
DATA: gt_carr LIKE TABLE OF gs_carr.

DATA: gs_pfli TYPE spfli.
DATA: gt_pfli LIKE TABLE OF gs_pfli.

DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_carr.
DATA:   count TYPE i,
      END OF gs_display.
DATA gt_display LIKE TABLE OF gs_display.


DATA: BEGIN OF gs_display_pfli.
        INCLUDE TYPE spfli.
DATA: END OF gs_display_pfli.
DATA gt_display_pfli LIKE TABLE OF gs_display_pfli.



DATA gv_lines TYPE i.


*--------------------------------------------------------------------*
* ALV 관련 변수(Variables)
*--------------------------------------------------------------------*
DATA go_container TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

DATA gs_variant TYPE disvariant.
DATA gv_save TYPE c.
DATA gs_layout TYPE lvc_s_layo.

DATA gt_fieldcat TYPE lvc_t_fcat.

DATA go_event_handler TYPE REF TO lcl_event_handler.

* SPFLI 출력을 위한 Container 및 ALV 관련 변수
DATA go_docking_container TYPE REF TO cl_gui_docking_container.
DATA go_alv_grid_pfli TYPE REF TO cl_gui_alv_grid.
DATA gt_fieldcat_pfli TYPE lvc_t_fcat.

*--------------------------------------------------------------------*
* Screen과 통신용 변수
*--------------------------------------------------------------------*
DATA ok_code TYPE sy-ucomm.
