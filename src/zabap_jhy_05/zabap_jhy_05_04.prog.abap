*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_04
*&---------------------------------------------------------------------*
*& Function Module 연습
*& 함수그룹 ZABAP_JHY_05_FG01 의 함수모듈을 호출하는 예제
*&
*& 함수그룹의 TOP 에서 선언한 전역변수의 값이 변경되는 과정을 보여줌
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_04.

" 자동차 속도를 기록할 전역변수
DATA my_car_speed TYPE i.

START-OF-SELECTION.

  PERFORM write_current_speed.


  WRITE  '==> 30만큼 속도 증가'.
  ULINE.
  CALL FUNCTION 'Z_ABAP_JHY_CAR_SPEED_INC'
    EXPORTING
      iv_speed = 30.                  " 현재 속도에서 얼마나 더 증가시킬 건지?

  PERFORM write_current_speed.


  WRITE  '==> 10만큼 속도 감소'.
  ULINE.
  CALL FUNCTION 'Z_ABAP_JHY_CAR_SPEED_DEC'
    EXPORTING
      iv_speed = 10.                 " 속도를 얼마나 감소시킬 건지?

  PERFORM write_current_speed.

*&---------------------------------------------------------------------*
*& Form WRITE_CURRENT_SPEED
*&---------------------------------------------------------------------*
FORM write_current_speed .

  CALL FUNCTION 'Z_ABAP_JHY_CAR_SPEED_GET'
    IMPORTING
      ev_speed = my_car_speed.  " 자동차의 현재 속도

  WRITE : / '자동차의 현재 속도는', my_car_speed, '입니다.'.

ENDFORM.
