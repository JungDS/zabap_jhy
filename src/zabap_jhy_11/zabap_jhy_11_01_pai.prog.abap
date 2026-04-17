*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_01_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      PERFORM init.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE'.
      PERFORM save_data.

    WHEN gc_tabstrip_tab1
      OR gc_tabstrip_tab2
      OR gc_tabstrip_tab3.

      my_tabstrip-activetab = ok_code.
      LEAVE SCREEN.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_SHPNM  INPUT
*&---------------------------------------------------------------------*
MODULE check_shpnm INPUT.

  CHECK ztjhy_shop-shpnm IS INITIAL.

  CLEAR ok_code.

  " & 는(은) 필수입니다.
  MESSAGE e005 WITH '가게이름'(l01).

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_TELNO  INPUT
*&---------------------------------------------------------------------*
MODULE check_telno INPUT.

  PERFORM check_telno.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_PSTCD  INPUT
*&---------------------------------------------------------------------*
MODULE check_pstcd INPUT.

  PERFORM check_pstcd.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_PSTCD  INPUT
*&---------------------------------------------------------------------*
MODULE f4_pstcd INPUT.

  CHECK go_dialog IS INITIAL.


  perform create_object_popup.
  perform set_html_event_popup.
  perform show_html_popup.

ENDMODULE.
