*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_08
*&---------------------------------------------------------------------*
*& Class 기반의 Exception 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_08.

DATA go_car1 TYPE REF TO zcl_jhy_car.
DATA go_car2 TYPE REF TO zcl_jhy_car.
DATA gx_model_check TYPE REF TO cx_root.

DATA gv_model TYPE char20.


START-OF-SELECTION.

  TRY.
      CREATE OBJECT go_car1
        EXPORTING
          iv_model = ''. " 자동차의 모델 정보를 기록하기 위한 Parameter

      " CREATE OBJECT가 Exception 발생하지 않으면 아래 문장을 수행한다.
      gv_model = go_car1->get_model( ).
      WRITE : / '1번 자동차 모델은', gv_model, '입니다.'.

    CATCH zcx_jhy_car_model_check INTO gx_model_check. " 자동차 모델을 점검하기 위한 Exception Class
*   CATCH CX_STATIC_CHECK         INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class
*   CATCH CX_ROOT                 INTO GX_MODEL_CHECK. " 자동차 모델을 점검하기 위한 Exception Class

* TRY ~ ENDTRY 사이에서 YCX_JHY_CAR_MODEL_CHECK 라는 Class 기반의 Exception이 발생할 경우
* 즉시 이 구간으로 이동해 아래의 로직을 실행한다.

      DATA lv_msg TYPE string.
      lv_msg = gx_model_check->get_text( ). " Exception 에서 에러메시지 가져오기

      " 가져온 에러메시지를 팝업으로 출력할 때 오류메시지처럼 보여주기.
      MESSAGE lv_msg TYPE 'I' DISPLAY LIKE 'E'.

  ENDTRY.


  CREATE OBJECT go_car2
    EXPORTING
      iv_model = 'AVANTE'. " 자동차의 모델 정보를 기록하기 위한 Parameter

  gv_model = go_car2->get_model( ).
  WRITE : / '2번 자동차 모델은', gv_model, '입니다.'.
