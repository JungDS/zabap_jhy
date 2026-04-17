*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_00
*&---------------------------------------------------------------------*
*& Chart Engine ( 직접 설정 )
*&---------------------------------------------------------------------*
REPORT zabap_jhy_09_00.


* [ INCLUDE ], [ ABAP Event ] 순으로 Main Program에 기록한다.

* 선언 관련 Include
INCLUDE zabap_jhy_09_00_top. " 전역변수
INCLUDE zabap_jhy_09_00_scr. " Selection Screen
INCLUDE zabap_jhy_09_00_cls. " Local Class Definition & Implementation ( 정의 구현 )

* 구현 관련 Include
INCLUDE zabap_jhy_09_00_pbo. " Process Before Output
INCLUDE zabap_jhy_09_00_pai. " Process After Input
INCLUDE zabap_jhy_09_00_f01. " FORM Subroutines


********************************************************* Initialization
INITIALIZATION.

  CLEAR: so_spmon, so_spmon[].
  so_spmon-sign = 'I'.
  so_spmon-option = 'BT'.
  so_spmon-low  = sy-datum(4) && '01'.
  so_spmon-high = sy-datum(6).

  APPEND so_spmon.

**************************************************** At Selection-screen
AT SELECTION-SCREEN.

***************************************************** Start-of-selection
START-OF-SELECTION.

  PERFORM set_period.
  PERFORM select_data.

* XML 문서파일 대신 XML 생성하는 오브젝트 취급
  go_ixml = cl_ixml=>create( ).
  go_ixml_sf = go_ixml->create_stream_factory( ).

  CALL SCREEN '100'.
