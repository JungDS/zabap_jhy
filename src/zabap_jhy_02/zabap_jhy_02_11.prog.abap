*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_11
*&---------------------------------------------------------------------*
*& Message 출력
*&---------------------------------------------------------------------*
REPORT zabap_jhy_02_11.


* MESSAGE 문은 다양한 TYPE을 통해 메시지를 출력한다.
* TYPE 'S' : 성공 메시지로 좌측 하단에 출력
* TYPE 'I' : 정보 메시지로 팝업으로 출력
* TYPE 'E' : 에러 메시지로 좌측 하단에 출력, 일부 상황을 제외하고 프로그램 종료
* TYPE 'W' : 경고 메시지로 좌측 하단에 출력, 일부 상황을 제외하고 프로그램 종료
* TYPE 'A' : 취소 메시지로 팝업으로 출력, 프로그램 종료
* TYPE 'X' : 장애 메시지로 프로그램을 즉시 중단하고 장애가 발생한 상황에 대해 출력

PARAMETERS pa_msgty TYPE msgty.

CASE pa_msgty.
  WHEN 'S'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
  WHEN 'I'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
  WHEN 'I'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
  WHEN 'I'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
  WHEN 'I'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
  WHEN 'I'.
    MESSAGE '직접 문장을 기록해서 출력하는 방법' TYPE pa_msgty.
ENDCASE.

MESSAGE '두번째 메시지' TYPE 'S'.
