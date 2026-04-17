*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_04_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.

  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN 'CANC'.

      " 화면 입력필드와 연결된 변수들 초기화
      CLEAR ztjhy_student.
      CLEAR ztjhy_depart.
      CLEAR ztjhy_departt.

      LEAVE SCREEN. " Next Screen으로 이동( 화면 새로고침 )

      " 이러면 화면의 입력필드가 전부 빈값으로 화면이 갱신된다.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_DATE  INPUT
*&---------------------------------------------------------------------*
MODULE check_date INPUT.

* 일자를 점검하는 로직이다.
* 조건1. 생일이 입력되어 있다면, 입학일보다 이전이여야 올바르다.
* 조건2. 졸업일자가 입력되어 있다면, 입학일보다 이후여야 올바르다.

  IF ztjhy_student-bdate IS NOT INITIAL AND
     ztjhy_student-bdate GE ztjhy_student-adate. " 생일 >= 입학일,

    " 예를 들어 생일은 2024.12.31 인데,
    " 입학일자는 2024.01.01 인 것처럼,
    " 생일이 더 큰 경우에는 말이 안되다.

    " 필드 점검에는 메시지를 출력할 때 항상 오류타입으로 출력한다.
    " TEXT-E02 : 생일과 입학일자가 올바르지 않습니다.
    MESSAGE TEXT-E02 TYPE 'E'.

  ENDIF.

  IF ztjhy_student-gdate IS NOT INITIAL AND
     ztjhy_student-gdate LT ztjhy_student-adate. " 졸업일 < 입학일

    " 이 경우는 입학일보다 졸업일이 앞선 경우로
    " 마찬가지로 말이 안되는 상황이다.

    " 필드 점검에서 팝업으로 메시지를 출력하고 싶으면,
    " 오류타입 메시지를 팝업(I) 처럼 취급하면 된다.
    " TEXT-E03 : 입학일자와 졸업일자를 확인하세요.
    MESSAGE TEXT-E03 TYPE 'E' DISPLAY LIKE 'I'.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_DPTCD  INPUT
*&---------------------------------------------------------------------*
MODULE check_dptcd INPUT.

* 학과 정보가 테이블에 존재하는지 점검하고,
* 로그인된 언어 기준으로 텍스트 정보도 가져온다.

  CLEAR ztjhy_departt-dptnm.

  DATA lv_dptnm TYPE ztjhy_departt-dptnm.

  SELECT SINGLE dptnm
    FROM ztjhy_departt
    INTO lv_dptnm
   WHERE dptcd EQ ztjhy_student-dptcd
     AND spras EQ sy-langu.

  " 만약 검색에 실패했거나, 성공해도 학과명이 비어있다면,
  " 등록된 학과명이 없다고 출력한다.
  IF lv_dptnm IS INITIAL.
    ztjhy_departt-dptnm = '등록된 학과명 없음'(e01).
  ELSE.
    " LV_DPTNM 에 학과명이 들어가있다면,
    " 화면에 보여줘야 하니깐 입력필드와 동일한 이름의 변수인
    " ztjhy_departt-DPTNM 에게 전달한다.
    ztjhy_departt-dptnm = lv_dptnm.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'SAVE'.
      PERFORM save_student.
  ENDCASE.

ENDMODULE.
