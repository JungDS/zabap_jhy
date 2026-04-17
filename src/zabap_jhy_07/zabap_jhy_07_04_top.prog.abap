*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_04_TOP
*&---------------------------------------------------------------------*

* Dictionary Structure
TABLES scarr.


* 데이터 검색 ( SELECT 문 ) 에서 사용하여 데이터를 보관하기 위한 itab
DATA: gt_data TYPE TABLE OF sflight,
      gs_data LIKE LINE OF gt_data.

* ALV 에서 사용하여 데이터를 출력하기 위한 itab
* SFLIGHT 의 데이터를 출력할 때, 일정을 취소할 수 있는 버튼이 필요하다면,
* 그 버튼은 오늘 이후인 예정일정만 취소가 되도록 해야할 것이다.
* 그러므로 특정 라인에만 버튼이 생기도록 gs_display에서 Style을 취급하도록 한다.
DATA: BEGIN OF gs_display,
        carrid       TYPE sflight-carrid,
        connid       LIKE sflight-connid,
        fldate       LIKE sflight-fldate,
        price        LIKE sflight-price,
        currency     LIKE sflight-currency,
        seatsmax     LIKE sflight-seatsmax,
        seatsocc     LIKE sflight-seatsocc,
        paymentsum   LIKE sflight-paymentsum,  " Dictionary 의 필드는 LIKE 도 가능
        cancel_bttxt TYPE char10,              " Data Element 는 LIKE로 사용불가
        style        TYPE lvc_t_styl,
      END OF gs_display,

      gt_display LIKE TABLE OF gs_display.


* 화면 변수
DATA: ok_code TYPE sy-ucomm.

* 100번 화면에서 ALV 를 출력하기 위한 변수들
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid,

      gs_layout    TYPE lvc_s_layo,
      gt_fieldcat  TYPE lvc_t_fcat,  " ALV 에서 출력 컬럼을 담당
      gs_fieldcat  TYPE lvc_s_fcat.
