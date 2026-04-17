*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_05_05_CLS
*&---------------------------------------------------------------------*


CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS write_alone.
    CLASS-METHODS class_constructor.
    METHODS constructor.
    METHODS write_hello.
  PRIVATE SECTION.
    METHODS secret_method.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD write_alone.
    WRITE : / '난 객체 없이도 실행 가능한 Public Static Method [ ','WRITE_ALONE' COLOR COL_TOTAL,' ]야'.
    WRITE : / '대신 클래스로 호출해줘'.
    ULINE.
  ENDMETHOD.
  METHOD class_constructor.
    WRITE : / 'Class LCL_TEST는 처음이지? 온 걸 환영해'.
    WRITE : / '나는 [ ','Static Constructor(클래스 생성자)' COLOR COL_KEY,' ] 야.'.
    WRITE : / 'Class LCL_TEST와 관련된 무엇이든 가장 처음엔 내가 먼저 실행되. 물론 한번만 실행되'.
    ULINE.
  ENDMETHOD.
  METHOD constructor.
    WRITE : / '객체를 생성하면 제가 자동으로 실행됩니다.'.
    WRITE : / '저는 [ ','Instance Constructor(생성자)' COLOR COL_GROUP,' ] 입니다.'.
    ULINE.
  ENDMETHOD.
  METHOD write_hello.
    WRITE : / '안녕하세요 저는 Public Instance Method [ ','WRITE_HELLO' COLOR COL_POSITIVE,' ] 입니다.'.
    WRITE : / '나는 Private에 접근이 가능해, 내가 SECRET_METHOD 메소드를 호출할게'.
    ULINE.
    CALL METHOD me->secret_method.
  ENDMETHOD.
  METHOD secret_method.
    WRITE : / '나는 외부에서 호출할 수 없는 Private Instance Method [ ', 'SECRET_METHOD' COLOR COL_NEGATIVE,' ]야'.
    ULINE.
  ENDMETHOD.
ENDCLASS.
