*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_02
*&---------------------------------------------------------------------*
*& Field Symbol 기초
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_02.

* GV_NAME 이라는 변수는 CHAR20 자리로 생성된 변수인데,
* GV_NAME 이라는 이름으로 접근이 가능하다.
DATA gv_name TYPE char20.

gv_name = '정훈영'.

WRITE: / '이름:', gv_name.


* CHAR20로 선언된 변수만 접근할 수 있는 Field Symbol
FIELD-SYMBOLS <fs_name> TYPE char20.


* 이미 생성된 변수에 접근할 때 정적인 기존의 이름 외에도 동적인 방식으로 접근하고자할 때 사용한다.
* 즉, 변수의 값에 접근할 수 있는 새로운 수단을 만드는 것
* ASSIGN 키워드를 통해 GV_NAME 변수는 <FS_NAME>으로도 접근이 가능하다.
* 이로인해 이 값에 접근할 수 있는 수단은 GV_NAME or <FS_NAME>이 된다.
ASSIGN gv_name TO <fs_name>.



IF <fs_name> IS ASSIGNED.

  <fs_name> = '홍길동'.  " 정훈영 => 홍길동으로 변경
*                        " GV_NAME 으로 접근해도 홍길동으로 변경된 값이 나온다.

  UNASSIGN <fs_name>.   " 목적을 다한 FS는 즉시 연결된 변수와의 관계를 끊는 것이 안전하다.
ENDIF.


WRITE: / '이름:', gv_name.
