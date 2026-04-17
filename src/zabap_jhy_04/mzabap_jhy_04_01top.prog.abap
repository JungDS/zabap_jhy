*&---------------------------------------------------------------------*
*& Include MZABAP_JHY_04_01TOP                      - Module Pool      SAPMZABAP_JHY_04_01
*&---------------------------------------------------------------------*
PROGRAM sapmzabap_jhy_04_01.

* 화면에서 버튼 등을 사용자가 눌렀을 때
* 해당 이벤트의 Function Code를 기록하기 위한 변수
DATA ok_code TYPE sy-ucomm.


CONSTANTS gc_mode_display TYPE i VALUE 0.
CONSTANTS gc_mode_change TYPE i VALUE 1.

DATA gv_mode TYPE i. " 0: DISPLAY, 1:CHANGE
