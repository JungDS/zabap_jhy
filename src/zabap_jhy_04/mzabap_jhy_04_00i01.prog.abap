*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_00I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
*     화면번호 0 으로 이동하겠다.
*     => 화면번호 0 는 항상 이전화면을 의미한다.
*     ==> 이전화면으로 이동하겠다. ===> 뒤로 간다.
    WHEN OTHERS.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SELECT_CARRIER_NAME  INPUT
*&---------------------------------------------------------------------*
MODULE select_carrier_name INPUT.

  DATA lv_carrid TYPE scarr-carrid.

* 입력필드로부터 값을 전달받은 SDYN_CONN-CARRID를 이용하여 항공사명을 조회한다.
  lv_carrid = sdyn_conn-carrid.

  CLEAR gv_carrname.

  SELECT SINGLE carrname
         FROM scarr
         INTO gv_carrname
         WHERE carrid EQ lv_carrid.

ENDMODULE.
