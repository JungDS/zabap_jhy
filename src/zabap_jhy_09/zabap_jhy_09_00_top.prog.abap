*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_TOP
*&---------------------------------------------------------------------*


TABLES sdyn_book.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: gv_spmon    TYPE spmon,
      gv_fldate_s TYPE sbook-fldate,
      gv_fldate_e TYPE sbook-fldate.

DATA: BEGIN OF gs_carr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        series   TYPE REF TO if_ixml_element,
      END OF gs_carr,
      gt_carr LIKE TABLE OF gs_carr.

*--------------------------------------------------------------------*
* 집계 데이터
*--------------------------------------------------------------------*
DATA: BEGIN OF gs_book_agg,
        carrid    TYPE sbook-carrid,
        spmon     TYPE c LENGTH 6,
        loccuram  TYPE wrbtr, " SBOOK-FORCURAM 대신 금액 단위가 큰 Data Element 사용
        loccurkey TYPE sbook-loccurkey,
        forcuram  TYPE wrbtr, " SBOOK-FORCURAM 대신 금액 단위가 큰 Data Element 사용
        forcurkey TYPE sbook-forcurkey,
        carrname  TYPE scarr-carrname,
      END OF gs_book_agg,

      gt_book_agg LIKE TABLE OF gs_book_agg.



*--------------------------------------------------------------------*
* 화면출력 관련 변수
*--------------------------------------------------------------------*
DATA: go_container TYPE REF TO cl_gui_custom_container.
DATA: go_chart_engine TYPE REF TO cl_gui_chart_engine.
DATA: go_event_handler TYPE REF TO lcl_event_handler.
DATA: go_ixml TYPE REF TO if_ixml.
DATA: go_ixml_sf TYPE REF TO if_ixml_stream_factory.

DATA: g_design_mode TYPE c.
DATA: g_value_change TYPE c.

DATA: ok_code LIKE sy-ucomm.
