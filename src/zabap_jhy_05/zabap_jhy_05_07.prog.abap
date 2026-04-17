*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_07
*&---------------------------------------------------------------------*
*& Local Class - Self 참조
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_07.


CLASS lcl_car DEFINITION.
  PUBLIC SECTION.

*   구별을 위해 IV_CAR_NUMBER_1, IV_CAR_NUMBER_2로 만듦
    METHODS constructor     IMPORTING iv_car_number_1 TYPE string.
    METHODS set_car_number  IMPORTING iv_car_number_2 TYPE string.
    METHODS get_car_number  RETURNING VALUE(rv_car_number) TYPE string.

  PRIVATE SECTION.

*   객체의 정보로 사용하기 위해 Instant Attribute를 만듦
    DATA car_number TYPE string.

ENDCLASS.

CLASS lcl_car IMPLEMENTATION.


* CONSTRUCTOR: 생성자 라고 불리며, 객체 생성 시 자동으로 호출되는 메소드
*   이 메소드는 객체 생성과 동시에 실행되는 [ Instance Method ]다.
*   모든 Instance Method는 작동할 때 현재 객체를 참조변수 [ ME ]로 접근할 수 있다.
*   현재 객체를 자신이라 부르기 때문에 Self 참조라고 부르기도 한다.

  METHOD constructor.

    me->set_car_number( iv_car_number_1 ).

    WRITE :/ '[ DATA CAR_NUMBER TYPE STRING. ]' COLOR COL_HEADING, '선언 전'.
*    ULINE.
    WRITE :/5(22) '    CAR_NUMBER의 값 :', (10) car_number, '==> Instance Attribute만 존재하므로 Attribute의 값이 출력된다.'.
    SKIP 2.

    DATA car_number TYPE string.
*    ULINE.
    WRITE :/ '[ DATA CAR_NUMBER TYPE STRING. ]' COLOR COL_HEADING, '선언 후'.
*    ULINE.
    car_number = 'ABCD'.

    WRITE :/5(22) '    CAR_NUMBER의 값 :', (10) car_number,    '==>지역변수의 값이 출력된다.'.
    WRITE :/5(22) 'ME->CAR_NUMBER의 값 :', (10) me->car_number,'==> Self 참조로 Instance Attribute의 값이 출력된다.'.
    SKIP 2.

  ENDMETHOD.
  METHOD set_car_number.
*   여기에서는 CAR_NUMBER 나 ME->CAR_NUMBER나 같다.

    car_number = iv_car_number_2.
    me->car_number = iv_car_number_2.

  ENDMETHOD.
  METHOD get_car_number.

    rv_car_number = car_number.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  DATA lo_car         TYPE REF TO lcl_car.
  DATA lo_car2        TYPE REF TO lcl_car.
  DATA lv_car_number  TYPE string.


* 자동차 객체 생성
  WRITE :/ '자동차 객체 생성, 생성할 때 전달된 값은 111가1111' COLOR COL_TOTAL.
  CREATE OBJECT lo_car
    EXPORTING
      iv_car_number_1 = '111가1111'.



* 자동차 객체 생성
  ULINE.
  WRITE :/ '자동차 객체 생성, 생성할 때 전달된 값은 111가1111' COLOR COL_TOTAL.
  CREATE OBJECT lo_car2
    EXPORTING
      iv_car_number_1 = '222나2222'.


* 번호 변경
  ULINE.
  WRITE : / '333다3333 으로 번호 변경' COLOR COL_TOTAL.
  WRITE : /4 '번호 변경 전: ', lo_car->get_car_number( ).

  lo_car->set_car_number( '333다3333' ).

  WRITE : /4 '번호 변경 후: ', lo_car->get_car_number( ).
