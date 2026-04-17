*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_06_01
*&---------------------------------------------------------------------*
*& Database View를 통해서 데이터를 조회
*&---------------------------------------------------------------------*
REPORT zabap_jhy_06_01 MESSAGE-ID zabap_jhy_msg.


*--------------------------------------------------------------------*
* 변수, Selection Screen(Parameters, Select-Options) 선언
*--------------------------------------------------------------------*

DATA: gs_flight  TYPE sv_flights,
      gt_flights TYPE TABLE OF sv_flights.

" Select Option은 선언할 때 FOR 뒤에 반드시
" 변수만 등장할 수 있다.
SELECT-OPTIONS: so_cityf FOR gs_flight-cityfrom,
                so_cityt FOR gs_flight-cityto.

*--------------------------------------------------------------------*
* ABAP Event ( 구현 )
*--------------------------------------------------------------------*
* Selection Screen 출력 전에 실행되는 이벤트 구간
*--------------------------------------------------------------------*
INITIALIZATION.

*--------------------------------------------------------------------*
* Selection Screen에서 사용자가 Enter나 실행 버튼 등을 클릭했을 때
* 실행되는 이벤트 구간, 주로 Selection Screen의 입력값 점검
*--------------------------------------------------------------------*
AT SELECTION-SCREEN.

*--------------------------------------------------------------------*
* 사용자가 Selection Screen에서 실행버튼을 클릭해서
* AT SELECTION-SCREEN 이 끝난 후 실행되는 이벤트 구간
* 실행버튼을 눌렀기 때문에 Selection Screen의 입력필드 값을 활용해서
* 데이터를 검색 및 결과를 화면에 출력하는 역할을 담당한다.
*--------------------------------------------------------------------*
START-OF-SELECTION.

* 데이터베이스 뷰를 활용해서 데이터를 가져온 방식

  SELECT *                        " 데이터를 가져올 필드
    FROM sv_flights               " SCARR + SPFLI + SFLIGHT
    UP TO 100 ROWS                " 최대 100줄만 조회
    INTO TABLE gt_flights         " TYPE TABLE OF SV_FLIGHTS
   WHERE cityfrom IN so_cityf
     AND cityto   IN so_cityt
     AND seatsocc LT sv_flights~seatsmax " LT 는 < 와 같은 Less Than, 보다 작다
   ORDER BY carrid connid fldate.


  IF sy-subrc EQ 0.
    CALL METHOD cl_demo_output=>display
      EXPORTING
        data = gt_flights.
  ELSE.
*   메시지 클래스의 000 메세지를 성공메시지 타입으로 출력한다.
*   성공메시지는 프로그램을 중단시키지 않고 메시지를 출력하는 특징이 있어서
*   Error 메시지처럼 보이도록 하면서 프로그램을 중단시키지 않을 수 있다.
*   000 메시지의 첫번째 &에는 TEXT-E01이 대체되어 출력된다.
    MESSAGE s000 DISPLAY LIKE 'E' WITH TEXT-e01. " 입력된 조건으로는 예약 가능한 비행정보가 없습니다.
  ENDIF.
