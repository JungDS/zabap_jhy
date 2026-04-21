*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_18
*&---------------------------------------------------------------------*
*& SALV ALV 출력 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_18.

DATA gt_scarr TYPE STANDARD TABLE OF scarr WITH EMPTY KEY.
DATA go_alv   TYPE REF TO cl_salv_table.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
SELECT-OPTIONS: s_carrid FOR scarr-carrid.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-t01 = 'ALV 조회 조건'.

START-OF-SELECTION.
  SELECT *
    FROM scarr
    INTO TABLE @gt_scarr
    WHERE carrid IN @s_carrid.

  IF gt_scarr IS INITIAL.
    WRITE: / '조회 결과가 없습니다.'.
    RETURN.
  ENDIF.

  TRY.
      " SALV 객체 생성
      cl_salv_table=>factory(
        IMPORTING r_salv_table = go_alv
        CHANGING  t_table      = gt_scarr ).

      " Zebra 패턴 적용
      go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      " 기본 정렬 적용 (CARRID 오름차순)
      go_alv->get_sorts( )->add_sort( columnname = 'CARRID' sequence = if_salv_c_sort=>sort_up ).

      " ALV 출력
      go_alv->display( ).

    CATCH cx_salv_msg INTO DATA(gx_salv).
      WRITE: / 'ALV 생성 중 오류:', gx_salv->get_text( ).
  ENDTRY.
