*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_06
*&---------------------------------------------------------------------*
*& Field Symbol 동적 변수 생성 및 활용
*&
*& 이 프로그램은 사용자가 입력한 Database Table 이름을 이용해서
*& 동적으로 진행되는 프로그램이다.
*&
*& 1. 사용자가 입력한 테이블을 조회한다.
*& 2. 사용자가 입력한 테이블을 Line Type으로 취급하는 Internal Table을 선언한다.
*&
*& 즉, 어떤 테이블을 입력해도 무조건 조회하고 보관할 수 있는 Itab을 자동으로 생성하고 출력한다.
*&
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_06.


DATA: go_ref TYPE REF TO data,
      go_alv TYPE REF TO cl_salv_table.

FIELD-SYMBOLS <fs_table> TYPE STANDARD TABLE.


PARAMETERS pa_tabnm TYPE tabname OBLIGATORY.

SELECTION-SCREEN BEGIN OF LINE.
* TEXT-S01 : 최대 조회가능 수
  SELECTION-SCREEN COMMENT (30) TEXT-S01 FOR FIELD PA_MAX.
  SELECTION-SCREEN POSITION POS_LOW.
  PARAMETERS pa_max   TYPE i DEFAULT 100.
* TEXT-M01 : 최대 100개의 데이터만 검색됩니다.
  SELECTION-SCREEN COMMENT (70) TEXT-m01.
SELECTION-SCREEN END OF LINE.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'PA_MAX'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN ON pa_tabnm.

  SELECT SINGLE FROM   dd02l
                FIELDS tabname
                WHERE  tabname EQ @pa_tabnm
                INTO   @pa_tabnm.

  CHECK sy-subrc NE 0.
  MESSAGE '테이블 이름이 잘못되었습니다.' TYPE 'E'.



START-OF-SELECTION.


  TRY.
*     전달받은 테이블 이름을 활용해 Internal Table 변수 생성하고 <FS_TABLE>로 가리킨다.
      CREATE DATA go_ref TYPE TABLE OF (pa_tabnm).
      ASSIGN go_ref->* TO <fs_table>.
    CATCH cx_sy_create_data_error.
      MESSAGE '인터널 테이블 생성 실패' TYPE 'E'.
  ENDTRY.


* 전달받은 테이블 이름을 활용해 데이터를 조회하고, 검색결과를 Internal Table <FS_TABLE>로 보관한다.
  SELECT FROM (pa_tabnm)
         FIELDS *
         INTO TABLE @<fs_table>
         UP TO 100 ROWS.          " 최대 100줄


* 데이터를 화면에 출력한다.
  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = <fs_table>
      ).

      go_alv->display( ).


    CATCH cx_salv_msg INTO DATA(lx_salv_msg).

      MESSAGE lx_salv_msg->get_text( ) TYPE 'I'.

  ENDTRY.
