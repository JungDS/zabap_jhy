*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_02_PBO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.  " BACK , EXIT , CANC

* ALV Grid 예제 ( Field Catalog + Event ) - 항공편 조회, & &
  SET TITLEBAR  'T0100' WITH sy-datum   " 타이틀에 현재 일자 및 시간이 출력된다.
                             sy-uzeit.
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

    PERFORM create_object_0100.
    PERFORM set_alv_fieldcatalog_0100.
    PERFORM set_alv_event_0100.
    PERFORM display_alv_0100.

  ENDIF.

  " BOUND : 연결된 객체가 있는지 검사
  IF go_container IS NOT BOUND. " IF GO_CONTAINER IS INITIAL. 과 같다.

  ENDIF.


ENDMODULE.
