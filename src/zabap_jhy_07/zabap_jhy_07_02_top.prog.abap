*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_02_TOP
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES scarr.
TABLES spfli.

* 테이블에서 데이터를 검색해서 보관할 Internal Table 선언
DATA gt_pfli TYPE TABLE OF spfli.

* ALV를 위해 새롭게 정의된 Structure
* - GT_PFLI에서 없는 ICON 필드가 ALV에서 출력하기 위해 추가되었다.
DATA: BEGIN OF gs_display.
        INCLUDE TYPE spfli.
DATA:   status TYPE icon-id, " 국내선/국제선을 구별하기 위한 아이콘 필드
      END OF gs_display.

* ALV와 연동될 Internal Table 선언
DATA gt_display LIKE TABLE OF gs_display.


DATA go_container TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.
DATA go_event_handler TYPE REF TO lcl_event_handler.

* ALV 컬럼에 대한 속성 정보를 다루는 Field Catalog
DATA gt_fieldcat TYPE lvc_t_fcat.
DATA gs_fieldcat TYPE lvc_s_fcat.

DATA ok_code TYPE sy-ucomm.
