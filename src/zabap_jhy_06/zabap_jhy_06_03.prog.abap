*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_06_03
*&---------------------------------------------------------------------*
*& SCARR → ZCARR 로 데이터 복사
*&---------------------------------------------------------------------*
REPORT zabap_jhy_06_03 MESSAGE-ID zabap_jhy_msg.

TABLES: sscrfields, scarr.

DATA gt_scarr TYPE TABLE OF scarr.
DATA gt_zcarr TYPE TABLE OF zcarr.
DATA go_salv_table TYPE REF TO cl_salv_table.
DATA go_salv_msg TYPE REF TO cx_salv_msg.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS so_car FOR scarr-carrid.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN PUSHBUTTON /1(30) TEXT-b01 USER-COMMAND copy_data.
SELECTION-SCREEN PUSHBUTTON 40(30) TEXT-b02 USER-COMMAND disp_data.
SELECTION-SCREEN PUSHBUTTON 80(30) TEXT-b03 USER-COMMAND dele_data.

AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'COPY_DATA'.
      PERFORM copy_data.

    WHEN 'DISP_DATA'.
      PERFORM disp_data.

    WHEN 'DELE_DATA'.
      PERFORM dele_data.

  ENDCASE.



*&---------------------------------------------------------------------*
*& Form COPY_DATA
*&---------------------------------------------------------------------*
FORM copy_data .

* SCARR의 데이터를 조회
  SELECT * FROM scarr INTO TABLE gt_scarr WHERE carrid IN so_car.

  IF sy-subrc NE 0.
    MESSAGE s008 DISPLAY LIKE 'W'. " 데이터를 찾을 수 없습니다.
    EXIT.                          " 현재 구역의 로직 중단 ( 현재 구역이 프로그램이므로, 프로그램 중단 )
  ENDIF.

* Internal Table끼리 서로 Field명이 동일한 데이터끼리만 값을 전달하도록 한다.
  MOVE-CORRESPONDING gt_scarr TO gt_zcarr.

  SORT gt_zcarr BY carrid.

* Internal Table에 기록된 데이터가 DB Table zcarr 에 삽입된다.
* 동일한 데이터가 이미 존재하는 경우 오류가 발생한다.
  TRY .
      INSERT zcarr FROM TABLE gt_zcarr.

*     테이블의 레코드 신규생성, 변경, 삭제 등에 확정처리
      COMMIT WORK.
      MESSAGE s000 WITH TEXT-m01. " 데이터 복사가 완료되었습니다.

    CATCH cx_sy_open_sql_db INTO DATA(lx_osql_db).

*     마지막으로 확정했던 상태로 복원된다. => 즉, 위의 DELETE, INSERT 문으로 삭제, 생성된 데이터가 복원된다.
      ROLLBACK WORK.

      DATA(lv_message) = lx_osql_db->get_longtext( ).
      MESSAGE lv_message TYPE 'E'.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISP_DATA
*&---------------------------------------------------------------------*
FORM disp_data .
  TRY .

      SELECT * FROM zcarr INTO TABLE gt_zcarr WHERE carrid IN so_car.

      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = go_salv_table " Basis Class Simple ALV Tables
        CHANGING
          t_table      = gt_zcarr.

      CALL METHOD go_salv_table->display.

    CATCH cx_salv_msg INTO go_salv_msg. " ALV: General Error Class with Message

      DATA lv_message TYPE string.
      lv_message = go_salv_msg->get_longtext( ).

      MESSAGE lv_message TYPE 'E'.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELE_DATA
*&---------------------------------------------------------------------*
FORM dele_data .
  TRY .


      DELETE FROM zcarr WHERE carrid IN so_car.

      IF sy-subrc EQ 0.

        MESSAGE s014. " 지정된 조건의 데이터가 성공적으로 삭제되었습니다.

      ELSE.

*       특별한 상황이 아닌 이상 삭제하려는 데이터가 없다고 오류로 취급해서는 안된다.
        MESSAGE s015 DISPLAY LIKE 'W'. " 지정된 조건의 데이터가 존재하지 않습니다.

      ENDIF.


    CATCH cx_salv_msg INTO go_salv_msg. " ALV: General Error Class with Message

      DATA lv_message TYPE string.
      lv_message = go_salv_msg->get_longtext( ).

      MESSAGE lv_message TYPE 'E'.

  ENDTRY.

ENDFORM.
