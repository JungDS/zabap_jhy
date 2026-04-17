*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* - Prefix 정의
*   1. PF-STATUS: Screen No
*   2. TITLEBAR : Screen No

  SET PF-STATUS 'S0100'.
  SET TITLEBAR  'T0100'. " ALV Grid 예제 3 ( 종합 활용 )

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0101 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0101 OUTPUT.

  SET PF-STATUS 'S0101'.
  SET TITLEBAR  'T0101'. " 항공기 정보

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'S0200'.
  SET TITLEBAR  'T0200'. " 항공편 정보

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
MODULE init_alv_0100 OUTPUT.

  "-- 화면의 GRID가 BOUND되었는지 확인한다.
  IF go_grid IS NOT BOUND.

    "-- Container와 ALV 객체를 생성한다.
    PERFORM create_object_0100.

    "-- GRID의 LAYOUT 속성을 정의한다.
    PERFORM set_alv_layout_0100.

    "-- ALV Standard Toolbar Button 제외항목 지정
    PERFORM set_alv_toolbar_exclude_0100.

    "-- ALV Sort
    PERFORM set_alv_sort_0100.

    "-- Field Attribute을 사용자의 요구사항에 맞게 변경
    PERFORM set_alv_fieldcat_0100.

    "-- ALV Events 등록
    PERFORM regist_alv_event_0100 USING go_grid.

    "-- ALV Display
    PERFORM display_alv_grid_0100.

  ELSE.

    "-- ALV Refresh
    PERFORM refresh_grid_0100 USING go_grid.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.

  CLEAR ok_code.

ENDMODULE.
