*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_01_TOP
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* Dictionary Structure
*--------------------------------------------------------------------*
TABLES ztjhy_shop.

*--------------------------------------------------------------------*
* Constants
*--------------------------------------------------------------------*
CONSTANTS gc_custctrl     TYPE scrfname VALUE 'CCON'.
CONSTANTS gc_waers_krw    TYPE waers    VALUE 'KRW'.

*--------------------------------------------------------------------*
* Internal Table & Structure
*--------------------------------------------------------------------*
DATA: gs_shop      TYPE ztjhy_shop.

DATA: gs_menu      TYPE ztjhy_menu,
      gt_menu      TYPE TABLE OF ztjhy_menu,

      gs_menu_text TYPE ztjhy_menut,
      gt_menu_text TYPE TABLE OF ztjhy_menut.

*--------------------------------------------------------------------*
* For Display
*--------------------------------------------------------------------*
DATA: BEGIN OF gs_display_menu.
        INCLUDE STRUCTURE ztjhy_menu.
DATA:   mennm  TYPE ztjhy_menut-mennm, " 메뉴명
        status TYPE icon-id,
        result TYPE bapiret2-message,
      END OF gs_display_menu,

      gt_display_menu LIKE TABLE OF gs_display_menu.

*--------------------------------------------------------------------*
* ALV 관련 변수
*--------------------------------------------------------------------*
DATA: go_docking  TYPE REF TO cl_gui_docking_container,
      go_alv_grid TYPE REF TO cl_gui_alv_grid.

DATA: gs_layout      TYPE lvc_s_layo,
      gt_fieldcat    TYPE lvc_t_fcat,
      gs_fieldcat    TYPE lvc_s_fcat,
      gs_stable      TYPE lvc_s_stbl,
      gv_alv_refresh TYPE c.

*DATA GS_VARIANT TYPE DISVARIANT.
*DATA GV_SAVE.

*--------------------------------------------------------------------*
*
*--------------------------------------------------------------------*
DATA ok_code          TYPE sy-ucomm.
DATA gv_error.
DATA gv_answer.
DATA gv_complete.


*--------------------------------------------------------------------*
* Tabstrip 을 위한 관련 변수
*--------------------------------------------------------------------*
CONTROLS   my_tabstrip       TYPE TABSTRIP.
DATA       gv_tabstrip_dynnr TYPE sy-dynnr.
CONSTANTS: gc_tabstrip_tab1 TYPE sy-ucomm VALUE 'TAB1',
           gc_tabstrip_tab2 TYPE sy-ucomm VALUE 'TAB2',
           gc_tabstrip_tab3 TYPE sy-ucomm VALUE 'TAB3'.


*--------------------------------------------------------------------*
* 우편번호 Popup을 위한 관련 변수
*--------------------------------------------------------------------*
DATA: go_ccon_0120  TYPE REF TO cl_gui_custom_container,
      go_html       TYPE REF TO cl_gui_html_viewer,

      go_dialog     TYPE REF TO cl_gui_dialogbox_container,
      go_html_popup TYPE REF TO cl_gui_html_viewer,

      gs_html       TYPE w3html,
      gt_html       TYPE w3html_tab.

*--------------------------------------------------------------------*
* Macro 정의
*--------------------------------------------------------------------*
DEFINE __free.
  IF &1 IS BOUND.
    &1->free( ).
  ENDIF.

  FREE &1.
END-OF-DEFINITION.
