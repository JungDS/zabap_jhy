*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0300 OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_ALV_0300 OUTPUT.

  "-- GO_CONTAINER와 연결된 객체가 있는지 점검한다.
  IF go_container IS NOT BOUND. " = is initial 과 동일

    "-- Container와 ALV 객체를 생성한다.
    PERFORM create_object_0300.

    "-- ALV Layout 속성을 정의한다.
    PERFORM SET_ALV_LAYOUT_0300.

    "-- ALV Sort
    PERFORM set_alv_sort_0300.

    "-- Field Attribute을 사용자의 요구사항에 맞게 변경
    PERFORM set_alv_fieldcat_0300.

    "-- ALV Display
    PERFORM display_alv_grid_0300.

  ELSE.

    "-- ALV Refresh
    PERFORM refresh_grid_0300.

  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
