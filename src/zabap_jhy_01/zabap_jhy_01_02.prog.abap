*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_02
*&---------------------------------------------------------------------*
*& Structure 변수 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_02.


* Structure 타입 선언
TYPES BEGIN OF ts_flightinfo.
TYPES carrid TYPE s_carr_id.
TYPES carrname TYPE s_carrname.
TYPES connid TYPE s_conn_id.
TYPES fldate TYPE s_date.
TYPES percentage TYPE p LENGTH 3 DECIMALS 2.
TYPES END OF ts_flightinfo.


* Structure 변수 선언 ( 선언할 때 사용된 타입이 Structure 타입이기 때문에 )
DATA gs_flightinfo TYPE ts_flightinfo.


* Structure 변수의 각 Component 별로 값을 기록
gs_flightinfo-carrid     = 'KA'.
gs_flightinfo-carrname   = '대한항공'.
gs_flightinfo-connid     = '1234'.
gs_flightinfo-fldate     = '20240101'.
gs_flightinfo-percentage = '97.12'.


* Structure 변수의 각 Component 별로 값을 출력
WRITE /01 '항공사ID:'.
WRITE  15 gs_flightinfo-carrid.

WRITE /01 '항공사명:'.
WRITE  15 gs_flightinfo-carrname.

WRITE /01 '항공편:'.
WRITE  15 gs_flightinfo-connid.

WRITE /01 '출발일자:'.
WRITE  15 gs_flightinfo-fldate.

WRITE /01 '예약율:'.
WRITE  15 gs_flightinfo-percentage.


ULINE.


* Structure 변수를 초기화하면, Structure 변수의 모든 Component의 값이 전부 초기화된다.
CLEAR gs_flightinfo.

* 초기화된 Structure 변수의 각 Component 별로 값을 출력
WRITE /01 '항공사ID:'.
WRITE  15 gs_flightinfo-carrid.
WRITE /01 '항공사명:'.
WRITE  15 gs_flightinfo-carrname.
WRITE /01 '항공편:'.
WRITE  15 gs_flightinfo-connid.
WRITE /01 '출발일자:'.
WRITE  15 gs_flightinfo-fldate.
WRITE /01 '예약율:'.
WRITE  15 gs_flightinfo-percentage.
