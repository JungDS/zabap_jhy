*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_03
*&---------------------------------------------------------------------*
*& Field Symbol 동적 활용 예시 1
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_03 MESSAGE-ID zabap_jhy_msg.


* Internal Table 선언
DATA gt_scarr TYPE TABLE OF scarr.
DATA gt_spfli TYPE TABLE OF spfli.
DATA gt_sflight TYPE TABLE OF sflight.
DATA gt_sbook TYPE TABLE OF sbook.



* 동적 assign을 위한 문자열 변수 선언
DATA gv_name TYPE string.


* SALV 를 위한 참조변수 선언
DATA: go_salv     TYPE REF TO cl_salv_table,
      gx_salv_msg TYPE REF TO cx_salv_msg.



* Standard Internal Table만 취급하는 Field Symbol
FIELD-SYMBOLS <fs_tab> TYPE STANDARD TABLE.



PARAMETERS pa_rb1 RADIOBUTTON GROUP rbg1. " 정적 Assign 방식
PARAMETERS pa_rb2 RADIOBUTTON GROUP rbg1. " 동적 Assign 방식
PARAMETERS pa_tab TYPE tabname.           " 문자 30자리

SELECTION-SCREEN SKIP.

PARAMETERS PA_CHK AS CHECKBOX.


INITIALIZATION.

  pa_tab = 'SCARR'.

AT SELECTION-SCREEN ON pa_tab.

  UNASSIGN <fs_tab>.

  CASE abap_on.
    WHEN pa_rb1.  " 정적 Assign 방식

*--------------------------------------------------------------------*
* 정적 Assign 방법  => 정확하지만, 로직이 길어진다.
*--------------------------------------------------------------------*
      CASE pa_tab.
        WHEN 'SCARR'.     ASSIGN gt_scarr   TO <fs_tab>.
        WHEN 'SPFLI'.     ASSIGN gt_spfli   TO <fs_tab>.
        WHEN 'SFLIGHT'.   ASSIGN gt_sflight TO <fs_tab>.
        WHEN 'SBOOK'.     ASSIGN gt_sbook   TO <fs_tab>.
        WHEN OTHERS.
          MESSAGE '테이블 이름을 다시 입력해주세요.' TYPE 'E'.
      ENDCASE.

      IF <fs_tab> IS ASSIGNED.
        MESSAGE i031 DISPLAY LIKE 'S'. " 정적 Assign이 성공했습니다.
      ELSE.
        MESSAGE e032 DISPLAY LIKE 'I'. " 정적 Assign이 실패했습니다.
      ENDIF.

    WHEN pa_rb2.  " 동적 Assign 방식

*--------------------------------------------------------------------*
* 동적 Assign 방법  => 로직이 심플하지만, 난이도가 높고, 존재하지 않는 변수를 가리키려고 해서 ASSIGN이 실패할 수도 있다.
*--------------------------------------------------------------------*
      gv_name = 'GT_' && pa_tab.
      ASSIGN (gv_name) TO <fs_tab>.

      IF sy-subrc EQ 0.
        MESSAGE i033 DISPLAY LIKE 'S'. " 동적 Assign이 성공했습니다.
      ELSE.
        MESSAGE e034 DISPLAY LIKE 'I'. " 동적 Assign이 실패했습니다.
      ENDIF.


  ENDCASE.



START-OF-SELECTION.


  CHECK <fs_tab> IS ASSIGNED.
  CHECK pa_chk   IS NOT INITIAL.


* 입력한 이름과 동일한 테이블에서 최대 100 줄의 데이터를 조회하여 <FS_TAB>과 연결된 Internal Table에 기록한다.
  SELECT * FROM (pa_tab) UP TO 100 ROWS INTO TABLE <fs_tab>.


* <FS_TAB>과 연결된 Internal Table을 전달하여 SALV로 출력하도록 한다.


*Selection texts
*----------------------------------------------------------
* PA_CHK         SALV 출력 여부
* PA_RB1         정적 Assign 방식
* PA_RB2         동적 Assign 방식
* PA_TAB         접근할 테이블 이름
  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_salv
        CHANGING
          t_table      = <fs_tab>
      ).

      go_salv->display( ).

    CATCH cx_salv_msg INTO gx_salv_msg.

  ENDTRY.
