*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_05_CLS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.

  " & 항공사의 예약 정보 조회 & &
  SET TITLEBAR  'T0100' WITH pa_car     " 첫번째 &
                             sy-datum   " 두번째 &
                             sy-uzeit.  " 세번째 &
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

    PERFORM create_object_0100.     " 컨테이너와 ALV의 객체 생성
    PERFORM set_alv_layout_0100.    " ALV의 전반적인 레이아웃 설정
    PERFORM set_alv_fieldcat_0100.  " ALV의 출력필드 설정
    PERFORM display_alv_0100.       " ALV를 화면에 출력하기 위해 데이터 전달

  ENDIF.

ENDMODULE.
