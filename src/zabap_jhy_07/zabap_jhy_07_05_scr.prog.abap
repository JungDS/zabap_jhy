*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_05_SCR
*&---------------------------------------------------------------------*

" TEXT-T01: Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  PARAMETERS pa_car TYPE scarr-carrid OBLIGATORY
                                      VALUE CHECK
                                      MEMORY ID car.

  SELECT-OPTIONS so_con FOR spfli-connid.
  SELECT-OPTIONS so_fld FOR sflight-fldate NO-EXTENSION.

  SELECTION-SCREEN SKIP.

* 회원번호 기준으로도 검색 가능
  SELECT-OPTIONS so_cid FOR sbook-customid.
  SELECT-OPTIONS so_ord FOR sbook-order_date NO-EXTENSION.

  SELECTION-SCREEN SKIP.

* 체크 시 취소한 예약건도 포함
* 체크 안하면 취소 건은 제외하고 조회한다.
  PARAMETERS pa_incan AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b01.
