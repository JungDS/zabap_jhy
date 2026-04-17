*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_06
*&---------------------------------------------------------------------*
*& CORRESPONDING #( ) 문법 기초
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_06.

* 비행기 모델: SFLIGHT의 키 + 가격 정보
TYPES: BEGIN OF ty_flight_price,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,       " 가격
         currency TYPE sflight-currency,
       END OF ty_flight_price.

* 가격 대신 Economy 좌석에 대한 필드가 있는 구조
TYPES: BEGIN OF ty_flight_seat,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         seatsmax TYPE sflight-seatsmax,    " Economy 좌석
         seatsocc TYPE sflight-seatsocc,
       END OF ty_flight_seat.

START-OF-SELECTION.

*--------------------------------------------------------------------*
* 1. 기초 예제: “같은 이름 필드 자동 매핑” (구조체 → 구조체)
*--------------------------------------------------------------------*
* 전달하는 Structure 변수는 피연산자에 해당하는 Structure 변수에게
* 동일한 이름의 컴포넌트(필드)은 자동으로 값이 복사되고,
* 값이 전달되지 않은 컴포넌트(필드)의 값은 초기화된다.
*--------------------------------------------------------------------*


  " 1) 좌석 정보가 있는 비행편 구조 생성
  DATA(ls_seat) = VALUE ty_flight_seat( carrid   = 'AA'
                                        connid   = '9999'
                                        fldate   = '20240101'
                                        seatsmax = 300
                                        seatsocc = 120 ).

  WRITE: / '=== BEFORE CORRESPONDING ===',
         / 'carrid   :', ls_seat-carrid,
         / 'connid   :', ls_seat-connid,
         / 'fldate   :', ls_seat-fldate,
         / 'seatsmax :', ls_seat-seatsmax,
         / 'seatsocc :', ls_seat-seatsocc.
  SKIP 2.


  " 2) 가격 정보가 있는 비행편 구조 생성
  DATA(ls_price) = VALUE ty_flight_price( carrid   = 'LH'
                                          connid   = '0400'
                                          fldate   = sy-datum
                                          price    = '1200'
                                          currency = 'EUR' ).

  " 3) CORRESPONDING 사용
  " - carrid, connid, fldate : 이름이 같으므로 자동 매핑
  " - price, currency        : ls_seat 에 없어서, 전달 안함
  " - seatsmax, seatsocc     : ls_seat 에 있지만, ls_price 에 없어서 초기화
  ls_seat = CORRESPONDING #( ls_price ). " # 은 피연산자의 타입인 ty_flight_seat 으로 취급됨


  " 3) 결과 확인
  WRITE: / '=== AFTER CORRESPONDING (NO BASE) ===',
         / 'carrid   :', ls_seat-carrid,
         / 'connid   :', ls_seat-connid,
         / 'fldate   :', ls_seat-fldate,
         / 'seatsmax :', ls_seat-seatsmax,
         / 'seatsocc :', ls_seat-seatsocc.
  SKIP 2.


*--------------------------------------------------------------------*
* 2. 기초 예제: BASE 사용해서 기존 데이터 유지
*--------------------------------------------------------------------*

  " 1) 좌석 정보가 있는 비행편 구조 생성
  ls_seat = VALUE ty_flight_seat( carrid   = 'AA'
                                  connid   = '9999'
                                  fldate   = '20240101'
                                  seatsmax = 300
                                  seatsocc = 120 ).

  " 2) CORRESPONDING + BASE 사용
  " - carrid, connid, fldate : 이름이 같으므로 자동 매핑
  " - price, currency        : ls_seat  에 없어서, 전달 안함
  " - seatsmax, seatsocc     : ls_price 에 없지만, BASE 로 지정한 LS_SEAT에 있어서 값 유지
  ls_seat = CORRESPONDING #( BASE ( ls_seat ) ls_price ).

  WRITE: / '=== AFTER CORRESPONDING (WITH BASE) ===',
         / 'carrid   :', ls_seat-carrid,
         / 'connid   :', ls_seat-connid,
         / 'fldate   :', ls_seat-fldate,
         / 'seatsmax :', ls_seat-seatsmax,
         / 'seatsocc :', ls_seat-seatsocc.


*--------------------------------------------------------------------*
* 기존 문법과 비교하면 다음과 같다.
*--------------------------------------------------------------------*
* CORRESPONDING        = CLEAR 후 MOVE-CORRESPONDING
* CORRESPONDING + BASE =          MOVE-CORRESPONDING
*--------------------------------------------------------------------*
