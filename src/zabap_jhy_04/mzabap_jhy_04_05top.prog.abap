*&---------------------------------------------------------------------*
*& Include MZABAP_JHY_04_05TOP                      - Module Pool      SAPMZABAP_JHY_04_05
*&---------------------------------------------------------------------*
PROGRAM sapmzabap_jhy_04_05.


* 화면의 FUNCTION CODE를 위한 변수 선언
DATA ok_code LIKE sy-ucomm.

* 계산된 결과값
DATA: gv_result     TYPE c LENGTH 30,
      gv_result_raw TYPE c LENGTH 30,
      gv_input      TYPE c LENGTH 30,
      gv_input_tmp  TYPE c LENGTH 30,
      gv_memory     TYPE c LENGTH 30,
      gv_operator   TYPE c LENGTH 30,
      gv_op_set     TYPE c,
      gv_length     TYPE i,
      gv_length_m   TYPE i.
