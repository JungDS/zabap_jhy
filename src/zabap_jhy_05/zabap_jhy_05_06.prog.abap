*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_06
*&---------------------------------------------------------------------*
*& Local Class - 상속 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_06.


CLASS lcl_human DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_name TYPE string.
    METHODS introduce_me.

  PROTECTED SECTION.
    DATA mv_name TYPE string.
ENDCLASS.

CLASS lcl_human IMPLEMENTATION.
  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD.
  METHOD introduce_me.
    WRITE : / '내 이름은', mv_name, '입니다.'.
  ENDMETHOD.
ENDCLASS.



CLASS lcl_student DEFINITION INHERITING FROM lcl_human.
  PUBLIC SECTION.
    METHODS constructor IMPORTING
                          iv_name   TYPE string
                          iv_school TYPE string.

    " 부모 클래스의 메소드를 다시 만들겠다고 정의함
    METHODS introduce_me REDEFINITION.

  PRIVATE SECTION.
    DATA mv_school TYPE string.
ENDCLASS.



CLASS lcl_student IMPLEMENTATION.
  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        iv_name = iv_name.

*   직접 물려받은 Attribute에 값을 전달할 수도 있지만,
*   부모의 생성자를 통해 진행하는 것이 좋다.
*   왜? 이후 부모 클래스에서 수정이 있을 때 자동으로 반영되니깐
*   me->mv_name   = iv_name.

    me->mv_school = iv_school.
  ENDMETHOD.
  METHOD introduce_me.
    WRITE : / '내 이름은', mv_name, '이고, 학교는', mv_school,'입니다.'.
  ENDMETHOD.
ENDCLASS.




START-OF-SELECTION.


  DATA lo_human   TYPE REF TO lcl_human.
  DATA lo_student TYPE REF TO lcl_student.

  CREATE OBJECT lo_human
    EXPORTING
      iv_name = '정훈영'.

  CREATE OBJECT lo_student
    EXPORTING
      iv_name   = '정훈영'
      iv_school = 'SAP고등학교'.

  CALL METHOD lo_human->introduce_me.
  CALL METHOD lo_student->introduce_me.
