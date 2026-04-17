*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_08
*&---------------------------------------------------------------------*
*& CORRESPONDING #( ) 문법 - Internal Table 활용
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_08.


* Table 타입을 위한 Structure 타입 선언
TYPES: BEGIN OF ty_flight,
         carrid     TYPE sflight-carrid,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         price      TYPE sflight-price,
         currency   TYPE sflight-currency,
         seatsocc_e TYPE sflight-seatsocc,
         seatsocc_b TYPE sflight-seatsocc_b,
         seatsocc_f TYPE sflight-seatsocc_f,
       END OF ty_flight.

* Table 타입 선언
TYPES tt_flight TYPE STANDARD TABLE OF ty_flight WITH EMPTY KEY.


START-OF-SELECTION.


* SFLIGHT에서 데이터 조회
  SELECT *
    FROM sflight
    INTO TABLE @DATA(lt_flight)
    UP TO 10 ROWS.

  " CORRESPONDING: Internal Table → Internal Table
  " - 라인 타입 기준으로 동일 이름 필드가 자동 매핑됨
  " - 이름이 다른 필드는 전부 초기화
  " - SEATSOCC_E 필드만 이름이 달라서 전달이 안됨
  DATA(lt_display) = CORRESPONDING tt_flight( lt_flight ).

  WRITE : /(9999) 'CORRESPONDING만 사용해서 값전달 ( seatsocc_e 필드에 값 없음 )' COLOR COL_HEADING.
  ULINE.
  LOOP AT lt_display INTO DATA(ls_display).
    WRITE: / ls_display-carrid,                           " 항공사 ID
             ls_display-connid,                           " 항공편 번호
             ls_display-fldate,                           " 비행일자
             ls_display-price,                            " 가격
             ls_display-currency,                         " 통화 코드
             ls_display-seatsocc_e COLOR COL_NEGATIVE,    " Economy  Class 예약수
             ls_display-seatsocc_b,                       " Business Class 예약수
             ls_display-seatsocc_f.                       " First    Class 예약수
  ENDLOOP.
  ULINE.

  SKIP 2.


  " CORRESPONDING: Internal Table → Internal Table
  " - 라인 타입 기준으로 동일 이름 필드가 자동 매핑됨
  " - 이름이 다른 필드는 전부 초기화
  " - SEATSOCC_E 필드는 SEATSOCC 필드에서 값을 전달받음
  lt_display = CORRESPONDING tt_flight( lt_flight MAPPING seatsocc_e = seatsocc ).

  WRITE : /(9999) 'CORRESPONDING + MAPPING을 사용해서 값전달 ( seatsocc_e 필드에도 값 전달 )' COLOR COL_HEADING.
  ULINE.
  LOOP AT lt_display INTO ls_display.
    WRITE: / ls_display-carrid,                           " 항공사 ID
             ls_display-connid,                           " 항공편 번호
             ls_display-fldate,                           " 비행일자
             ls_display-price,                            " 가격
             ls_display-currency,                         " 통화 코드
             ls_display-seatsocc_e COLOR COL_POSITIVE,    " Economy  Class 예약수
             ls_display-seatsocc_b,                       " Business Class 예약수
             ls_display-seatsocc_f.                       " First    Class 예약수
  ENDLOOP.
  ULINE.
