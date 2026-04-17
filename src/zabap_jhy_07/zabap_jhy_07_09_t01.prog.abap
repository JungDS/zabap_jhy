*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_T01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Tables
*----------------------------------------------------------------------*
TABLES: spfli,
        sflight,
        saplane.

TYPE-POOLS: icon, abap.

*----------------------------------------------------------------------*
* Constants
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. GC_  : Global Constants
* - EX). CONSTANTS: GC_E  TYPE C VALUE 'E'.

CONSTANTS gc_container_name TYPE scrfname VALUE 'CCON'.


*----------------------------------------------------------------------*
* Types
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. TY_  : Global, Local Types

TYPES: BEGIN OF ty_saplane,
          planetype   TYPE saplane-planetype,
          seatsmax    TYPE saplane-seatsmax,
          seatsmax_b  TYPE saplane-seatsmax_b,
          seatsmax_f  TYPE saplane-seatsmax_f,
       END OF ty_saplane.

*----------------------------------------------------------------------*
* Variable
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. GV_  : Global Variable
*   2. LV_  : Local Variable

*EX) DATA: ok_code   TYPE sy-ucomm,   "예외
*          gv_answer TYPE c.

DATA: ok_code   TYPE sy-ucomm,   "예외
      gv_answer TYPE c,
      gv_error  TYPE c.

*----------------------------------------------------------------------*
* Structure
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. GS_  : Global Structure
*   2. LS_  : Local Structure

*EX) DATA: GS_SFLIGHT TYPE SFLIGHT

DATA: gs_sflight TYPE sflight.
DATA: gs_display TYPE ZSJHY_07_09.

DATA: gs_saplane TYPE ty_saplane.

*----------------------------------------------------------------------*
* Internal Table
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. GT_  : Global Internal Table
*   2. LT_  : Local Internal Table

*EX) DATA: GT_SFLIGHT TYPE TABLE OF SFLIGHT

DATA: gt_sflight      TYPE TABLE OF sflight.
DATA: gt_display      LIKE TABLE OF gs_display. "출력용 Itab
DATA: gt_display_del  LIKE TABLE OF gs_display. "삭제된 데이터

DATA: gt_saplane      LIKE SORTED TABLE OF gs_saplane
                      WITH UNIQUE KEY planetype.



*----------------------------------------------------------------------*
*  Local Class Definition                                              *
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. LCL_  : Local Class Definition
* - EX). CLASS LCL_EVENT_RECEIVER DEFINITION DEFERRED.

CLASS lcl_event_receiver DEFINITION DEFERRED.


*----------------------------------------------------------------------*
*  Reference Varialbles for Class/Interfaces                           *
*----------------------------------------------------------------------*
* - Prefix 정의
*   1. GO_  : Global Reference Varialbles

* EX).
*DATA: GO_CONTAINER       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
*      GO_SPLITTER        TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
*      GO_CONTAINER_TOP   TYPE REF TO CL_GUI_CONTAINER,
*      GO_CONTAINER_BOT   TYPE REF TO CL_GUI_CONTAINER,
*      GO_DOCKING         TYPE REF TO CL_GUI_DOCKING_CONTAINER,
*      GO_GRID_TOP        TYPE REF TO CL_GUI_ALV_GRID,
*      GO_GRID_BOT        TYPE REF TO CL_GUI_ALV_GRID,
*      GO_GRID            TYPE REF TO CL_GUI_ALV_GRID,
*      GO_EVENT_RECEIVER  TYPE REF TO LCL_EVENT_RECEIVER.

DATA: go_container       TYPE REF TO cl_gui_custom_container,
      go_splitter        TYPE REF TO cl_gui_splitter_container,
      go_container_top   TYPE REF TO cl_gui_container,
      go_container_bot   TYPE REF TO cl_gui_container,
      go_docking         TYPE REF TO cl_gui_docking_container,
      go_grid_top        TYPE REF TO cl_gui_alv_grid,
      go_grid_bot        TYPE REF TO cl_gui_alv_grid,
      go_grid            TYPE REF TO cl_gui_alv_grid,
      go_event_receiver  TYPE REF TO lcl_event_receiver,

      "Dynamic Documents
      go_container_html  TYPE REF TO cl_gui_container,
      go_html_cntrl      TYPE REF TO cl_gui_html_viewer,
      go_document        TYPE REF TO cl_dd_document.

*----------------------------------------------------------------------*
*  Global Internal Table                                               *
*----------------------------------------------------------------------*
*DATA: GT_FIELDCAT TYPE LVC_T_FCAT,
*      GT_SORT     TYPE LVC_T_SORT,
*      GT_ROWS     TYPE LVC_T_ROW,
*      GT_STYLE    TYPE LVC_T_STYL,
*      GT_COLOR    TYPE LVC_T_SCOL,
*      GT_F4       TYPE LVC_T_F4,
*      GT_EXCLUDE  TYPE UI_FUNCTIONS. " 가능한 Layout으로 제어할 것

DATA: gt_fieldcat TYPE lvc_t_fcat,
      gt_sort     TYPE lvc_t_sort,
      gt_rows     TYPE lvc_t_row,
      gt_style    TYPE lvc_t_styl,
      gt_color    TYPE lvc_t_scol,
      gt_f4       TYPE lvc_t_f4,
      gt_exclude  TYPE ui_functions.

*----------------------------------------------------------------------*
*  Global Structure                                                    *
*----------------------------------------------------------------------*
*DATA: GS_VARIANT  TYPE DISVARIANT,
*      GS_LAYOUT   TYPE LVC_S_LAYO,
*      GS_FIELDCAT TYPE LVC_S_FCAT,
*      GS_SORT     TYPE LVC_S_SORT,
*      GS_ROW      TYPE LVC_S_ROW,
*      GS_COL      TYPE LVC_S_COL,
*      GS_STYLE    TYPE LVC_S_STYL,
*      GS_COLOR    TYPE LVC_S_SCOL,
*      GS_STABLE   TYPE LVC_S_STBL,
*      GS_F4       TYPE LVC_S_F4.

DATA: gs_variant  TYPE disvariant,
      gs_layout   TYPE lvc_s_layo,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_sort     TYPE lvc_s_sort,
      gs_row      TYPE lvc_s_row,
      gs_col      TYPE lvc_s_col,
      gs_style    TYPE lvc_s_styl,
      gs_color    TYPE lvc_s_scol,
      gs_stable   TYPE lvc_s_stbl,
      gs_f4       TYPE lvc_s_f4.


*----------------------------------------------------------------------*
*  Global Variant                                                      *
*----------------------------------------------------------------------*
*DATA: GV_CONTAINER TYPE SCRFNAME VALUE 'CCON',
*      GV_SAVE      TYPE C        VALUE 'A',
*      GV_POS       TYPE I,
*      GV_REPID     TYPE SY-REPID.

DATA: gv_save      TYPE c        VALUE 'A'.
