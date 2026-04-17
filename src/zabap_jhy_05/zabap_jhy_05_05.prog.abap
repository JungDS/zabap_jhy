*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_05
*&---------------------------------------------------------------------*
*& Local Class - Constructor 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_05.

INCLUDE zabap_jhy_05_05_cls.

DATA go_test TYPE REF TO lcl_test.

START-OF-SELECTION.

*
  SKIP .
  WRITE / '* LCL_TEST=>WRITE_ALONE 호출 *' COLOR COL_HEADING.
  ULINE.
  CALL METHOD lcl_test=>write_alone.

* GO_TEST 와 연결된 객체가 있는지 검사
* [ 연결된 객체란? ] : CREATE OBJECT를 통해 생성된 객체의 정보를 가진 경우
*                   or 다른 참조변수에게 객체정보를 전달받은 경우
  IF go_test IS BOUND.
    WRITE / '이건 호출되지 않아.'.
    CALL METHOD go_test->write_hello.
  ENDIF.

  SKIP 3.
  WRITE / '* CREATE OBJECT GO_TEST : 객체 생성 *' COLOR COL_HEADING.
  ULINE.
  CREATE OBJECT go_test.

  SKIP 3.
  WRITE / '* CREATE OBJECT GO_TEST : 객체 생성 *' COLOR COL_HEADING.
  ULINE.
  CREATE OBJECT go_test.

  SKIP 3.
  WRITE / '* GO_TEST 검사 후 WRITE_HELLO 메소드 호출 *' COLOR COL_HEADING.
  ULINE.
  IF go_test IS BOUND.
    CALL METHOD go_test->write_hello.
  ENDIF.

*  Private Section의 Method는 호출 불가
*  CALL METHOD GO_TEST->SECRET_METHOD.
