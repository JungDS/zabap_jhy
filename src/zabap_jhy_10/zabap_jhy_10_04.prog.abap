*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_04
*&---------------------------------------------------------------------*
*& SELECT-OPTIONS 에 VALUE #( ) 사용하기
*& Structure 구조의 값을 직접 표현하는 방법
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_04.

TABLES scarr.

SELECT-OPTIONS so_car FOR scarr-carrid.

INITIALIZATION.

*--------------------------------------------------------------------*
* 기존 문법
*--------------------------------------------------------------------*
* SO_CAR[]의 변화를 직접 확인하세요.
  BREAK-POINT.
  CLEAR so_car.
  so_car-sign   = 'I'.
  so_car-option = 'BT'.
  so_car-low    = 'AA'.
  so_car-high   = 'ZZ'.
  APPEND so_car.

  CLEAR so_car.
  so_car-sign   = 'E'.
  so_car-option = 'EQ'.
  so_car-low    = 'DL'.
  so_car-high   = ''.
  APPEND so_car.

*--------------------------------------------------------------------*
* 신 문법 #1
*--------------------------------------------------------------------*
* SO_CAR[]의 변화를 직접 확인하세요.
  BREAK-POINT.
  CLEAR   so_car.
  REFRESH so_car.

* Structure 형태의 값을 전달하는 방법
  so_car = VALUE #( sign   = 'I'
                    option = 'BT'
                    low    = 'AA'
                    high   = 'ZZ' ).
  APPEND so_car.

  so_car = VALUE #( sign   = 'E'
                    option = 'EQ'
                    low    = 'DL' ).
  APPEND so_car.

*--------------------------------------------------------------------*
* 신 문법 #2
*--------------------------------------------------------------------*
* SO_CAR[]의 변화를 직접 확인하세요.
  BREAK-POINT.
  CLEAR   so_car.
  REFRESH so_car.

* 배열 형태의 값을 전달하는 방법
  so_car[] = VALUE #( ( sign = 'I' option = 'BT' low = 'AA' high = 'ZZ' ) ).

* 앞서 전달했던 라인이 없어진다.
  so_car[] = VALUE #( ( sign = 'E' option = 'EQ' low = 'DL' ) ).

* BASE itab을 함께 적으면 기존 테이블의 데이터에 추가시킬 수 있다.
  REFRESH so_car.
  so_car[] = VALUE #( ( sign = 'I' option = 'BT' low = 'AA' high = 'ZZ' ) ).
  so_car[] = VALUE #( BASE so_car[] ( sign = 'E' option = 'EQ' low = 'DL' ) ).

* 배열 형태로 전달할 때 여러 줄도 가능하다.
  so_car[] = VALUE #( ( sign = 'I' option = 'BT' low = 'AA' high = 'ZZ' )
                      ( sign = 'E' option = 'EQ' low = 'DL' ) ).
