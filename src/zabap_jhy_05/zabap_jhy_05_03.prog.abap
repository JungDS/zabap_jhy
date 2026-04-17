*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_03
*&---------------------------------------------------------------------*
*& Subroutine Parameter - Call By Reference
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_03 LINE-SIZE 255.


* 전역변수(Global Variable) 선언
DATA gv_a TYPE i.
DATA gv_b TYPE i.

* GV_A와 GV_B 에 초기값을 설정한다.
gv_a = 10.
gv_b = 20.

WRITE :/ 'Call By Reference 의 실행 전' COLOR COL_HEADING.
WRITE :/ 'GV_A = ', gv_a.
WRITE :/ 'GV_B = ', gv_b.
ULINE.

* 서브루틴을 호출할 때 변수 GV_A와 GV_B가 사용된다.
PERFORM double_reference USING    gv_a
                         CHANGING gv_b.

WRITE :/ 'Call By Reference 의 실행 후' COLOR COL_HEADING.
WRITE :/ 'GV_A = ', gv_a.
WRITE :/ 'GV_B = ', gv_b.

*--------------------------------------------------------------------*
* CALL BY REFERENCE 에 해당하는 FORM 선언
* 아래 FORM 에는 Parameter가 2개 있다.( PV_A , PV_B )
*--------------------------------------------------------------------*
FORM double_reference USING pv_a TYPE i    " GV_A이 PV_A 라는 이름으로 사용된다.
                            pv_b TYPE i.   " GV_B이 PV_B 라는 이름으로 사용된다.

  pv_a = pv_a * 2.
  pv_b = pv_b * 2.

  WRITE :/ 'Subroutine 안에서의 PV_A, PV_B를 2배로 변경' COLOR COL_HEADING.
  WRITE :/ 'PV_A = ', pv_a.
  WRITE :/ 'PV_B = ', pv_b.
  ULINE.

ENDFORM. " Subroutine이 끝나는 것과 관계없이 실시간으로 반영된다.
