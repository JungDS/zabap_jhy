*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_04_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.

  " 항공일정 관리 ( 일정 취소 ) & &
  SET TITLEBAR  'T0100' WITH sy-datum   " 현재 일자
                             sy-uzeit.  " 현재 시간
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

  IF go_container IS INITIAL.
    PERFORM create_object_0100.     " Container 와 ALV 객체 생성
    PERFORM set_alv_layout_0100.    " ALV 의 레이아웃 설정
    PERFORM set_alv_fieldcat_0100.  " ALV 의 필드 카탈로그 설정
    PERFORM set_alv_event_0100.     " ALV 의 이벤트 설정 ( 핸들러 메소드 )
    PERFORM display_alv_0100.       " ALV 를 화면에 출력하기 위한 데이터 전달
  ENDIF.

ENDMODULE.
