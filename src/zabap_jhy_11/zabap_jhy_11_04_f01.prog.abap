*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_04_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SAVE_STUDENT
*&---------------------------------------------------------------------*
FORM save_student .

  CLEAR gv_error.

  " 저장하기 전에 학번과 생성정보를 기록한다.
  PERFORM get_student_id.

  CHECK gv_error IS INITIAL.

  ztjhy_student-erdat = sy-datum. " 현재일자를 생성일자로
  ztjhy_student-erzet = sy-uzeit. " 현재시간을 생성시간으로
  ztjhy_student-ernam = sy-uname. " 현재사용자를 생성자로

  " 원래는 바로 아래의 문장이 올바르나, TABLES 로 선언한 변수는
  " 테이블과 이름이 똑같아서 생략한다.
*  X INSERT ztjhy_student FROM ztjhy_student.
*  O INSERT ztjhy_student.

  " TABLES 가 아니라 DATA로 변수를 선언했다면?
  DATA ls_std TYPE ztjhy_student.
  MOVE-CORRESPONDING ztjhy_student TO ls_std.

  INSERT ztjhy_student FROM ls_std.

  " 이처럼 FROM 절 뒤에 Structure 변수를 작성한다.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_STUDENT_ID
*&---------------------------------------------------------------------*
FORM get_student_id .

  " 학번은 Number Range로 자동채번하고자 한다.
  " 학과별로 채번기준을 나누었고, 다시 연도별로 나누었다.
  " 채번은 숫자 3자리로 다뤄진다.
  DATA lv_seq TYPE n LENGTH 3.
  DATA lv_return_code LIKE inri-returncode.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'                    " Number range number
      object                  = 'ZJHYSTDID'             " Name of number range object
      toyear                  = ztjhy_student-adate(4)  " Value of To-fiscal year
    IMPORTING
      number                  = lv_seq              " free number
      returncode              = lv_return_code
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

    CASE lv_return_code.
      WHEN '0'.
        " 여유
      WHEN '1'.
        " 부족!!!
      WHEN '2'.
        " 마지막 번호 부여
      WHEN OTHERS.
        " 마지막 번호 부여
    ENDCASE.

    " 학번은 입학일자의 연도별로 채번된다.
    ztjhy_student-stdid = ztjhy_student-adate(4) && ztjhy_student-dptcd && lv_seq.

  ELSE.
    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno DISPLAY LIKE sy-msgty
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    gv_error = abap_on.
  ENDIF.


ENDFORM.
