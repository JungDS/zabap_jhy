*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_05_TOP
*&---------------------------------------------------------------------*

TABLES: scarr,
        spfli,
        sflight,
        sbook.

DATA: BEGIN OF gs_data,
        carrid     LIKE scarr-carrid,      " 항공사ID
        carrname   LIKE scarr-carrname,    " 항공사명

        connid     LIKE spfli-connid,      " 항공편번호
        countryfr  LIKE spfli-countryfr,   " 출발국가
        countryto  LIKE spfli-countryto,   " 도착국가

        fldate     LIKE sflight-fldate,    " 비행일자
        price      LIKE sflight-price,     " 가격
        currency   LIKE sflight-currency,  " 통화

        bookid     LIKE sbook-bookid,      " 예약번호
        customid   LIKE sbook-customid,    " 고객번호
        customname LIKE scustom-name,      " 고객이름
        order_date LIKE sbook-order_date,  " 예약일자
        class      LIKE sbook-class,       " 좌석등급
        loccuram   LIKE sbook-loccuram,    " 지불금액
        loccurkey  LIKE sbook-loccurkey,   " 통화
        smoker     LIKE sbook-smoker,      " 흡연여부
        cancelled  LIKE sbook-cancelled,   " 취소여부
      END OF gs_data.

DATA: BEGIN OF gs_display,
*        INCLUDE STRUCTURE GS_DATA.        " GS_DATA 로 적은 내용이
*                                          " 그대로 GS_DISPLAY 에 기록된다.

        status     LIKE icon-id,           " 체크:이미 출발한 비행기, 공란:아직 출발하지 않은 비행기

* 여기서부터는 GS_DATA와 동일한 필드 구성
        carrid     LIKE scarr-carrid,      " 항공사ID
        carrname   LIKE scarr-carrname,    " 항공사명

        connid     LIKE spfli-connid,      " 항공편번호
        countryfr  LIKE spfli-countryfr,   " 출발국가
        countryto  LIKE spfli-countryto,   " 도착국가

        fldate     LIKE sflight-fldate,    " 비행일자
        price      LIKE sflight-price,     " 가격
        currency   LIKE sflight-currency,  " 통화

        bookid     LIKE sbook-bookid,      " 예약번호
        customid   LIKE sbook-customid,    " 고객번호
        customname LIKE scustom-name,      " 고객이름
        order_date LIKE sbook-order_date,  " 예약일자
        class      LIKE sbook-class,       " 좌석등급
        loccuram   LIKE sbook-loccuram,    " 지불금액
        loccurkey  LIKE sbook-loccurkey,   " 통화
        smoker     LIKE sbook-smoker,      " 흡연여부
        cancelled  LIKE sbook-cancelled,   " 취소여부
* 여기까지가 GS_DATA와 동일한 필드 구성의 끝

        light      TYPE c,          " Exception Field
        cell_color TYPE lvc_t_scol, " Cell 단위 컬러
      END OF gs_display.


DATA: gt_data    LIKE TABLE OF gs_data,
      gt_display LIKE TABLE OF gs_display.


DATA ok_code TYPE sy-ucomm.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA:
* ALV의 전반적인 레이아웃 설정을 위한 변수
  gs_layout   TYPE lvc_s_layo,

* ALV의 출력되는 컬럼의 속성을 다루기 위한 변수
  gt_fieldcat TYPE lvc_t_fcat,
  gs_fieldcat TYPE lvc_s_fcat,

* ALV의 형태를 저장하거나 아니면 이미 저장된 형태를 불러오는 기능을 사용하기 위한 변수
  gs_variant  TYPE disvariant,
  gv_save     TYPE c.
