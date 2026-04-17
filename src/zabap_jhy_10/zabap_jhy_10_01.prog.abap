*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_01
*&---------------------------------------------------------------------*
*& 객체 생성 => CREATE OBJECT와 NEW에 대해서
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_01.


* ALV를 위한 Container & ALV Grid 참조변수 선언
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.


*--------------------------------------------------------------------*
* 기존 문법
*--------------------------------------------------------------------*
CREATE OBJECT go_container
  EXPORTING
    container_name              = 'CCON'    " Name of the Screen CustCtrl Name to Link Container To
  EXCEPTIONS
    cntl_error                  = 1         " CNTL_ERROR
    cntl_system_error           = 2         " CNTL_SYSTEM_ERROR
    create_error                = 3         " CREATE_ERROR
    lifetime_error              = 4         " LIFETIME_ERROR
    lifetime_dynpro_dynpro_link = 5         " LIFETIME_DYNPRO_DYNPRO_LINK
    OTHERS                      = 6.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CREATE OBJECT go_alv_grid
  EXPORTING
    i_parent          = go_container     " Parent Container
  EXCEPTIONS
    error_cntl_create = 1                " Error when creating the control
    error_cntl_init   = 2                " Error While Initializing Control
    error_cntl_link   = 3                " Error While Linking Control
    error_dp_create   = 4                " Error While Creating DataProvider Control
    OTHERS            = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.


*--------------------------------------------------------------------*
* 신문법 #1
* - new 키워드를 사용해서 생성된 객체 정보를 대입기호(=)의 좌측에 전달
*--------------------------------------------------------------------*
* 장점.
*  - 기존 문법 대비 훨씬 간결하다.
* 단점.
*  - 간결하게 표현하는 만큼 생략된 의미가 많아서 이해하기 쉽지 않다.
*--------------------------------------------------------------------*
go_container = NEW cl_gui_custom_container( container_name = 'CCON' ).
go_alv_grid  = NEW cl_gui_alv_grid( i_parent = go_container ).

*--------------------------------------------------------------------*
* 신문법 #2
* - 클래스 대신에 #을 쓰면, 대입기호(=) 좌측의 참조변수의 클래스로 객체를 생성한다.
* - 필수 파라메터가 하나인 경우 ( ) 안의 이름 생략 가능
*--------------------------------------------------------------------*
go_container = NEW #( 'CCON' ).
go_alv_grid  = NEW #( go_container ).

*--------------------------------------------------------------------*
* 신문법 #3
* - new 키워드 사용해서 생성과 동시에 전달 가능
*--------------------------------------------------------------------*
go_alv_grid = NEW #( NEW cl_gui_custom_container( 'CCON' ) ).
