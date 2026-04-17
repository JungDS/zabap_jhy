*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_01
*&---------------------------------------------------------------------*
*& Subroutine Parameter - Call By Value
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_01.


* 전역변수(Global Variable) 선언
DATA gv_a TYPE i.
DATA gv_b TYPE i.

* GV_A와 GV_B 에 초기값을 설정한다.
gv_a = 10.
gv_b = 20.

WRITE :/ 'Call By Value 의 실행 전' COLOR COL_HEADING.
WRITE :/ 'GV_A = ', gv_a.
WRITE :/ 'GV_B = ', gv_b.
ULINE.

* 서브루틴을 호출할 때 변수 GV_A와 GV_B의 값을 전달한다.
PERFORM double_value USING gv_a
                           gv_b.

WRITE :/ 'Call By Value 의 실행 후' COLOR COL_HEADING.
WRITE :/ 'GV_A = ', gv_a.
WRITE :/ 'GV_B = ', gv_b.

*--------------------------------------------------------------------*
* CALL BY VALUE에 해당하는 FORM 선언
* 아래 FORM 에는 Parameter가 2개 있다.( PV_A , PV_B )
*--------------------------------------------------------------------*
FORM double_value USING VALUE(pv_a) TYPE i " 첫번째 값이 PV_A에 전달된다.
                        VALUE(pv_b) TYPE i.   " 두번째 값이 PV_B에 전달된다.

  pv_a = pv_a * 2.
  pv_b = pv_b * 2.

  WRITE :/ 'Subroutine 안에서의 PV_A, PV_B를 2배로 변경' COLOR COL_HEADING.
  WRITE :/ 'PV_A = ', pv_a.
  WRITE :/ 'PV_B = ', pv_b.
  ULINE.

ENDFORM. " Subroutine이 끝나도 전달했던 A와 B는 값이 변경되지 않는다.
