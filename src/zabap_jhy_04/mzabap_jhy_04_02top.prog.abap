*&---------------------------------------------------------------------*
*& Include MZABAP_JHY_04_02TOP                      - Module Pool      SAPMZABAP_JHY_04_02
*&---------------------------------------------------------------------*
PROGRAM sapmzabap_jhy_04_02  MESSAGE-ID zabap_jhy_msg.


* 최소한 뒤로가기 버튼 기능이라도 구현하기 위해서 OK_CODE 필드가 반드시 필요하다.
* 제일 먼저 무지성으로 선언해도 전혀 문제 없다.
DATA ok_code TYPE sy-ucomm.


DATA gv_input TYPE text45.

* 101 번 화면의 입력필드와 데이터를 전송하기 위한 변수
DATA: BEGIN OF scr0101,
        input LIKE gv_input,
      END OF scr0101.

* 102 번 화면의 입력필드와 데이터를 전송하기 위한 변수
DATA: BEGIN OF scr0102,
        input LIKE gv_input,
      END OF scr0102.
