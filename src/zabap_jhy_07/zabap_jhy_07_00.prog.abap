*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_00
*&---------------------------------------------------------------------*
*& SALV ( Simple ABAP List Viewer )
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_00.


* 화면에 출력할 데이터를 취급하기 위한 Internal Table
DATA gt_spfli TYPE TABLE OF spfli.


* SALV에 필요한 참조변수 선언
DATA go_salv TYPE REF TO cl_salv_table.
DATA gx_salv_msg TYPE REF TO cx_salv_msg.

DATA go_columns_table TYPE REF TO cl_salv_columns_table.



START-OF-SELECTION.


* Database Table SPFLI 에서 모든 데이터를 전부 가져와
* Internal Table GT_SPFLI 에 키필드 기준으로 정렬해서 담는다.
  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
   ORDER BY PRIMARY KEY.


  TRY.

*     FACTORY 메소드는 Static Method다. 왜? 클래스로 호출하니까
*     출력할 데이터가 저장된 Internal Table을 전달하면 SALV로 출력할 수 있는 객체를 생성해준다.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = go_salv " Basis Class Simple ALV Tables
        CHANGING
          t_table      = gt_spfli.

*     컬럼 테이블 정보를 가져와서 열 넓이 최적화를 적용한다.
      CALL METHOD go_salv->get_columns
        RECEIVING
          value = go_columns_table.

      CALL METHOD go_columns_table->set_optimize.

*     DISPLAY 메소드는 Instance Method다.
*     SALV 객체를 통해 화면에 데이터를 출력한다.
      CALL METHOD go_salv->display.


    CATCH cx_salv_msg INTO gx_salv_msg. " ALV: General Error Class with Message

*     일부 Method는 호출 시 Class 기반의 Exception이 발생할 수 있다.
*     발생한 Exception에 대해서 내용을 확인하기 위해서는 아래와 같이 구현한다.

      DATA lv_msg TYPE string.

*     오류 메시지의 내용을 LV_MSG에 기록한다.
      CALL METHOD gx_salv_msg->get_text
        RECEIVING
          result = lv_msg.

      MESSAGE lv_msg TYPE 'I'.
*     MESSAGE '이 오류는 ~~~한 상황입니다.' TYPE 'I'.

  ENDTRY.
