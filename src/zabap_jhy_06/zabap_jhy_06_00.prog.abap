*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_06_00
*&---------------------------------------------------------------------*
*& SELECT ~ GROUPBY 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_06_00.


*--------------------------------------------------------------------*
* 항공편 정보를 취급할 Structure와 Internal Table 변수
*--------------------------------------------------------------------*
DATA: BEGIN OF gs_data,
        carrid      TYPE spfli-carrid,       " 항공사ID
        connid      TYPE spfli-connid,       " 항공편번호
        seatsmax    TYPE sflight-seatsmax,   " 이코노미 최대좌석수
        seatsocc    TYPE sflight-seatsocc,   " 이코노미 예약좌석수
        n_o_flights TYPE i,                  " 그룹화된 비행일정수
      END OF gs_data.

DATA gt_data LIKE TABLE OF gs_data.


*--------------------------------------------------------------------*
* Selection Screen 구성
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: pa_wr RADIOBUTTON GROUP rbg DEFAULT 'X',  " Write
              pa_sa RADIOBUTTON GROUP rbg.              " Simple ALV
SELECTION-SCREEN END OF BLOCK b01.



*--------------------------------------------------------------------*
* Selection Screen의 실행 ( Selection Screen 이 없는 경우 자동 실행 )
*--------------------------------------------------------------------*
START-OF-SELECTION.

* 비행일정 테이블에서 항공사, 항공편, 출발도시, 도착도시를 그룹화하여
* 최대좌석수 합계와 예약좌석수 합계와 그룹화된 비행일정의 개수를 조회하는 SELECT 문
  SELECT carrid
         connid
         SUM( seatsmax )
         SUM( seatsocc )
         COUNT(*)
    FROM sflight
    INTO TABLE gt_data
   GROUP BY carrid
            connid.


  CASE abap_on.
    WHEN pa_wr.

*     내용을 구별할 컬럼 헤더
      WRITE: /(10) '항공사',
              (10) '항공편',
              (20) '이코노미 최대좌석수' RIGHT-JUSTIFIED,
              (20) '이코노미 예약좌석수' RIGHT-JUSTIFIED,
              (12) '비행일정 수'         RIGHT-JUSTIFIED.

*     컬럼 헤더 크기에 맞춰 출력
      LOOP AT gt_data INTO gs_data.
        WRITE: /(10) gs_data-carrid,
                (10) gs_data-connid,
                (20) gs_data-seatsmax,
                (20) gs_data-seatsocc,
                (12) gs_data-n_o_flights.
      ENDLOOP.

    WHEN pa_sa.

      DATA lo_salv TYPE REF TO cl_salv_table.
      TRY.

* Class의 Static Method를 호출하는 문법 2가지
*   1. 구문법: CALL METHOD 클래스=>정적메소드 ...
*         CALL METHOD cl_salv_table=>factory
*           IMPORTING
*             r_salv_table = lo_salv
*           CHANGING
*             t_table      = gt_data.

*   2. 신문법: 클래스=>정적메소드( ... )
          cl_salv_table=>factory(
            IMPORTING
              r_salv_table = lo_salv
            CHANGING
              t_table      = gt_data
          ).


*         신문법을 활용하면, 수학의 함수처럼( y = f(x) ) 메소드의 결과값(Return Parameter)이
*         대입기호(=)를 통해 좌측으로 전달된다.
          DATA(lo_columns) = lo_salv->get_columns( ).

*         또한 신문법을 적절히 사용하면 다수의 Method를 굉장히 간결한 형태로 호출할 수 있다.
          lo_columns->get_column( 'N_O_FLIGHTS' )->set_long_text( '비행일정 수' ).
          lo_columns->set_optimize( ).


          lo_salv->display( ).


        CATCH cx_salv_msg. " ALV: General Error Class with Message
          MESSAGE 'SALV 출력 중 오류가 발생했습니다.' TYPE 'E'.

*       Inline Declaration for Variables을 통해 변수를 사용하는 순간 선언할 수 있다.
        CATCH cx_salv_not_found INTO DATA(lx_salv_not_found).
*         발생한 Exception의 메시지를 에러 메시지로 출력한다.
          DATA(lv_msg) = lx_salv_not_found->get_longtext( ).
          MESSAGE lv_msg TYPE 'E'.
      ENDTRY.

  ENDCASE.
