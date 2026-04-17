*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

* 화면에 Function Code 를 지닌 버튼들을 만들어준다.
* 그 Function Code 를 지닌 버튼을 누르면, OK_CODE 에 기록되고,
* PAI 모듈이 작동한다. PAI 모듈이 전부 끝나면, Next Screen 으로 이동한다.
* 해당 Next Screen 출력 전에 Next Screen 의 PBO 모듈이 먼저 작동한다.
* 하여 Next Screen 의 PBO 모듈이 완료된 후에야 Next Screen 의 모습이 보여진다.
  SET PF-STATUS 'S0100'.

* 화면에 제목을 붙여준다.
  SET TITLEBAR  'T0100' WITH sy-datum sy-uzeit. " 항공편 조회 ( ALV 연습 ) & &

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0100 OUTPUT.

* CREATE OBJECT <== 라는 문법은 실행될 때마다 객체를 매번 생성한다.
*                   그러나 2회 이상 생성되어서는 안되므로, 항상 상태를 확인해야 한다.
  IF go_container IS INITIAL.

    PERFORM create_object_0100. " Con 와 ALV 를 생성하는 과정이 있다.

*   ALV 에 대한 레이아웃 설정
    PERFORM set_alv_layout_0100.

*   ALV 에 출력되는 필드에 대한 추가 설정 ( FIELD CATALOG )
    PERFORM set_alv_fieldcat_0100.

*   ALV 에 대한 이벤트 핸들러 등록
    PERFORM set_alv_event_0100.

*   ALV 에게 관련 정보를 전달하여 화면에 데이터를 출력시킨다.
    PERFORM display_alv_0100.

  ELSE. " GO_CONTAINER IS NOT INITIAL

*   ALV와 연결된 Internal Table의 내용으로 새로고침한다.
    CALL METHOD go_alv_grid->refresh_table_display.

  ENDIF.


ENDMODULE.
