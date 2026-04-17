*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_03
*&---------------------------------------------------------------------*
*& VALUE #() 문법 - 비행기 모델로 만든 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_03.

START-OF-SELECTION.


*--------------------------------------------------------------------*
* 1. 초급: 항공사(SCARR) 및 항공편(SPFLI) Structure 변수에 값 전달
*--------------------------------------------------------------------*

  " 1) 항공사 구조체 값 할당
  DATA: ls_scarr TYPE scarr.
  ls_scarr = VALUE #( carrid   = 'AA'
                      carrname = 'American Airlines'
                      currcode = 'USD' ).

  " 2) 인라인 선언으로 항공편 정보 생성
  DATA(ls_spfli) = VALUE spfli( carrid   = 'LH'
                                connid   = '0400'
                                cityfrom = 'FRANKFURT'
                                cityto   = 'NEW YORK' ).


*--------------------------------------------------------------------*
* 2. 중급: 항공 일정(SFLIGHT) 테이블 생성 및 추가
*--------------------------------------------------------------------*

  DATA: lt_sflight TYPE TABLE OF sflight.

  " 1) 여러 항공편 일정을 한꺼번에 테이블에 담기
  lt_sflight = VALUE #(
    ( carrid = 'JL' connid = '0401' fldate = '20240101' price = '500.00' )
    ( carrid = 'SQ' connid = '0001' fldate = '20240102' price = '700.00' )
  ).

  " 2) BASE 활용: 기존 리스트(lt_sflight)를 유지하면서 대한항공(KE) 일정 추가
  lt_sflight = VALUE #( BASE lt_sflight
    ( carrid = 'KE' connid = '0701' fldate = '20240103' price = '900.00' )
  ).


*--------------------------------------------------------------------*
* 3. 고급: 날짜를 기준으로 조건별 데이터 생성 (FOR + COND)
*--------------------------------------------------------------------*

  " 원본 데이터: SFLIGHT에서 가격 기준으로 정렬해서 읽어옴
  SELECT FROM sflight
         FIELDS carrid, fldate, price, currency
         ORDER BY price
         INTO TABLE @DATA(lt_flight).


  " 결과 구조 정의 (항공사, 날짜, 가격, 상태)
  TYPES: BEGIN OF ty_flight,
           carrid   TYPE sflight-carrid,
           fldate   TYPE sflight-fldate,
           price    TYPE sflight-price,
           currency TYPE sflight-currency,
           status   TYPE string,
         END OF ty_flight.

  " 테이블 타입 선언
  TYPES: tt_flight TYPE TABLE OF ty_flight WITH EMPTY KEY.


*--------------------------------------------------------------------*
* VALUE + FOR + IN 방식
*--------------------------------------------------------------------*

  " 선언된 테이블 타입을 VALUE 연산자 뒤에 직접 작성하면, lt_report 변수가 선언될 때 타입으로 사용된다.
  DATA(lt_report) = VALUE tt_flight(

      " FOR 반복: 원본 테이블(lt_flight)을 한 행씩 읽어서 wa 로 반복
      FOR wa IN lt_flight ( carrid   = wa-carrid
                            fldate   = wa-fldate
                            price    = wa-price
                            currency = wa-currency

                            " COND: 오늘 날짜(sy-datum)와 비행일자(fldate)를 비교하여 상태 결정
                            status = COND #(  WHEN wa-fldate < sy-datum    " 오늘보다 이전 날짜
                                              THEN `Completed`             " 완료된 비행

                                              WHEN wa-fldate > sy-datum    " 오늘보다 이후 날짜
                                              THEN `Scheduled`             " 예정된 비행

                                              ELSE `On Schedule`           " 오늘 날짜와 같음 (당일 비행)
                                     )
      )
  ).


*--------------------------------------------------------------------*
* VALUE + FOR + IN + LET 방식
*--------------------------------------------------------------------*
  DATA(lt_report_v2) = VALUE tt_flight(

    FOR wa IN lt_flight

    " LET 구문으로 임시 변수(lv_today)를 선언하여 가독성 향상
    LET lv_today = sy-datum IN ( carrid = wa-carrid
                                 fldate = wa-fldate
                                 price    = wa-price
                                 currency = wa-currency

                                 " COND: lv_today 와 비행일자(fldate)를 비교하여 상태 결정
                                 status = COND #( WHEN wa-fldate < lv_today THEN `Completed`
                                                  WHEN wa-fldate > lv_today THEN `Scheduled`
                                                                            ELSE `On Schedule` )
                               )
  ).

* LET 으로 선언한 변수는 ( ) 안에서만 사용 가능하다.
* CLEAR lv_today. <== 오류 발생


  BREAK-POINT.

  " 두 방식의 결과 동일 여부 비교
  IF lt_report EQ lt_report_v2.
    WRITE / '두 테이블의 데이터가 동일하다.'.
  ELSE.
    WRITE / '두 테이블의 데이터가 다르다.'.
  ENDIF.
