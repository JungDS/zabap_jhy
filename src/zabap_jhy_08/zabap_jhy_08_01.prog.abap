*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_01
*&---------------------------------------------------------------------*
*& Number Range 연습
*&
*& T-code SNRO 에서 [ ZCAFE_NO ]라는 이름의 Number Ragne Object를 생성했다.
*& 이 Object는 순환이 가능하며, Domain은 NUMC2, 경고수준은 20%로 설정했다.
*& Main Memory Buffering으로 10개씩 사용되며, 이는 기본설정이지만
*& 실무에서는 상황에 따라, Buffering 기능을 끄는 경우도 있다.
*& 등록된 숫자범위는 [ ZZ ] 이라는 이름으로 01 ~ 99 까지 범위를 가진다.
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_01 MESSAGE-ID zabap_jhy_msg.

TABLES sscrfields.

* TEXT-L01 : ZCAFE_NO의 ZZ 숫자범위 기준으로 다음번호 발급
SELECTION-SCREEN PUSHBUTTON /1(50) TEXT-l01 USER-COMMAND btn_click.
* TEXT-L02 : 한번에 7개의 번호를 발급하기
SELECTION-SCREEN PUSHBUTTON /1(50) TEXT-l02 USER-COMMAND btn_click2.
SELECTION-SCREEN SKIP 1. " 한 줄 건너띄기
SELECTION-SCREEN COMMENT /1(50) stat_txt.


DATA gv_number TYPE numc2.

INITIALIZATION.
  stat_txt = '누르면 번호가 발급됩니다.'(m01).

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'BTN_CLICK'.
      PERFORM number_get_next USING 1 CHANGING gv_number.
      stat_txt = |발급된 번호는 { gv_number } 입니다.|.
    WHEN 'BTN_CLICK2'.
      PERFORM number_get_next USING 7 CHANGING gv_number.
      stat_txt = |발급된 번호는 { gv_number } 입니다.|.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Form NUMBER_GET_NEXT
*&---------------------------------------------------------------------*
FORM number_get_next  USING    pv_quantity      TYPE inri-quantity
                      CHANGING VALUE(cv_number) TYPE numc2.

  DATA lv_rc TYPE inri-returncode.


  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = 'ZZ'         " Number range number
      object                  = 'ZCAFE_NO'   " Name of number range object
      quantity                = pv_quantity
    IMPORTING
      number                  = cv_number    " free number
      returncode              = lv_rc        " Return code
    EXCEPTIONS
      interval_not_found      = 1 " Interval not found
      number_range_not_intern = 2 " Number range is not internal
      object_not_found        = 3 " Object not defined in TNRO
      quantity_is_0           = 4 " Number of numbers requested must be > 0
      quantity_is_not_1       = 5 " Number of numbers requested must be 1
      interval_overflow       = 6 " Interval used up. Change not possible.
      buffer_overflow         = 7 " Buffer is full
      OTHERS                  = 8.

  IF sy-subrc EQ 0.

    CASE lv_rc.
      WHEN space.
        MESSAGE s020. " 성공적으로 번호가 부여되었습니다.
      WHEN '1'.
        MESSAGE i021 DISPLAY LIKE 'W'. " 성공적으로 번호가 부여되었지만 남아 있는 번호가 경고 수준입니다.
      WHEN '2'.
        MESSAGE i022 DISPLAY LIKE 'W'. " 부여할 수 있는 범위의 마지막 번호가 부여되었습니다.
      WHEN '3'.
        MESSAGE i023 DISPLAY LIKE 'W'. " 남은 번호가 부족한 관계로 가능한 만큼만 부여되었습니다.
    ENDCASE.
  ELSE.
    MESSAGE i024 DISPLAY LIKE 'E'. " 다음 번호를 발급하지 못하고 실패했습니다.
  ENDIF.

ENDFORM.
