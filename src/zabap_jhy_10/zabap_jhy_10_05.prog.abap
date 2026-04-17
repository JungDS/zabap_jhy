*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_05
*&---------------------------------------------------------------------*
*& VALUE #() 문법 고급응용
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_05.

START-OF-SELECTION.

*--------------------------------------------------------------------*
* 예시를 위한 Type 선언
*--------------------------------------------------------------------*
  TYPES ty_i_tab TYPE STANDARD TABLE OF i WITH EMPTY KEY.

*--------------------------------------------------------------------*
* VALUE #() 안에 FOR를 이용해 여러 줄을 생성
*--------------------------------------------------------------------*
* 10줄의 데이터가 LT_NUMS에 기록된다.
*--------------------------------------------------------------------*
* 첫번째 줄에는 정수 [ 1 ]
* 두번째 줄에는 정수 [ 2 ]
* 세번째 줄에는 정수 [ 3 ] ... 열번째 줄까지 기록한다.
*--------------------------------------------------------------------*
  DATA(lt_nums) = VALUE ty_i_tab( FOR n = 1      " 반복 변수 n 선언 및 초기값 설정 (n = 1부터 시작)
                                  THEN n + 1     " 반복 1회가 끝날 때마다 n의 다음 값 정의 (n = n + 1)
                                  WHILE n <= 10  " 반복을 계속할 조건 (n이 10 이하일 때만 반복)
                                  ( n )          " 각 반복마다 Internal Table에 추가될 행 데이터
                                ).


*--------------------------------------------------------------------*
* [실무활용-1] SELECT 결과 → 출력용 ITAB 변환
*--------------------------------------------------------------------*

  " 1) DB 조회용 Internal Table
  DATA lt_scarr TYPE STANDARD TABLE OF scarr WITH EMPTY KEY.

  SELECT * FROM scarr INTO TABLE lt_scarr.

  " 2) ALV 출력용 Structure 정의
  TYPES: BEGIN OF ty_scarr_alv,
           carrid   TYPE scarr-carrid,    " 항공사 ID
           carrname TYPE scarr-carrname,  " 항공사명
           currency TYPE scarr-currcode,  " 통화 코드
           label    TYPE string,          " DB에 없는 신규 필드
         END OF ty_scarr_alv.

  DATA lt_display TYPE STANDARD TABLE OF ty_scarr_alv WITH EMPTY KEY.

  " 3) VALUE #( ) + FOR + IN 조합하여 반복하며 데이터 전달
  lt_display = VALUE #(

    FOR s IN lt_scarr                               " FOR + IN : 기존 테이블을 한 줄씩 반복한다.

    LET lv_label = |{ s-carrid } - { s-carrname }|  " LET : LV_LABEL을 임시 생성하고 값 설정

    IN ( carrid   = s-carrid                        " 기존 필드 매핑
         carrname = s-carrname
         currency = s-currcode
         label    = lv_label )                      " label에는 LV_LABEL의 값이 기록된다.

  ).

* LOOP + APPEND + MOVE-CORRESPONDING 없이 한 줄로 해결
* => 장점. 속도
* => 단점. 문법 이해도 필요, 신문법 적응 필요


*--------------------------------------------------------------------*
* [실무활용-2] SELECT 결과 → 특정 조건의 데이터만 ITAB 기록
*--------------------------------------------------------------------*
  lt_display = VALUE #(

    FOR s IN lt_scarr WHERE ( currcode = 'USD' OR currcode = 'EUR' )   " WHERE : 반복 조건

    LET lv_status = COND string( WHEN s-currcode = 'USD' THEN 'DOLLAR'
                                 WHEN s-currcode = 'EUR' THEN 'EURO'
                                 ELSE 'OTHER' )
    IN ( carrid   = s-carrid
         carrname = s-carrname
         currency = s-currcode
         label    = lv_status )   " label에는 [ DOLLAR 또는 EURO ]만 기록된다.
                                  " 왜? WHERE 조건으로 USD, EUR 통화코드만 반복하니깐
  ).



*--------------------------------------------------------------------*
* 기존 문법 vs 신 문법 차이 비교
*--------------------------------------------------------------------*
* 기존 문법
*--------------------------------------------------------------------*
  DATA: ls_scarr     LIKE LINE OF lt_scarr,
        ls_display   LIKE LINE OF lt_display,
        lt_display_2 LIKE lt_display.

  REFRESH lt_display.

  LOOP AT lt_scarr INTO ls_scarr.

    CLEAR ls_display.

    " 동일한 필드명끼리 데이터를 전달
    MOVE-CORRESPONDING ls_scarr TO ls_display.

    " 필드명이 다른 경우 데이터는 직접 전달
    ls_display-currency = ls_scarr-currcode.

    " 어떤 로직에 의해 가공된 값 전달
    " 여기서는 두 필드와 ' - '을 결합했다.
    CONCATENATE ls_scarr-carrid
                ls_scarr-carrname
           INTO ls_display-label
      SEPARATED BY ' - '.

    APPEND ls_display TO lt_display.

  ENDLOOP.

  BREAK-POINT.

*--------------------------------------------------------------------*
* 신 문법으로 해결한 첫번째 방식
*--------------------------------------------------------------------*
  lt_display_2 = VALUE #( FOR s IN lt_scarr
                          LET lv_label = |{ s-carrid } - { s-carrname }|
                          IN ( CORRESPONDING #( s MAPPING currency = currcode
                                                          label    = DEFAULT lv_label ) ) ).

*--------------------------------------------------------------------*
* 신 문법으로 해결한 두번째 방식
*--------------------------------------------------------------------*
  lt_display_2 = VALUE #( FOR s IN lt_scarr
                          LET lv_label = |{ s-carrid } - { s-carrname }|
                          IN ( VALUE #( BASE CORRESPONDING #( s )
                                             currency = s-currcode
                                             label    = lv_label ) ) ).

*--------------------------------------------------------------------*
* 신 문법으로 해결한 세번째 방식, 가장 라인 수가 적음
*--------------------------------------------------------------------*
  lt_display_2 = VALUE #( FOR s IN lt_scarr
                          ( VALUE #( BASE CORRESPONDING #( s )
                                          currency = s-currcode
                                          label    = |{ s-carrid } - { s-carrname }| ) ) ).


* 능숙해지기만 하면, 문장이 확연히 줄어들 수 있다.
  BREAK-POINT.

  IF lt_display EQ lt_display_2.
    WRITE / '기존 문법과 신 문법의 결과가 동일하다.'.
  ELSE.
    WRITE / '기존 문법과 신 문법의 결과가 다르다.'.
  ENDIF.
