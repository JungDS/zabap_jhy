*&---------------------------------------------------------------------*
*& Include          MZABAP_JHY_04_02F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form CHECK_INPUT_0101
*&---------------------------------------------------------------------*
FORM check_input_0101 .

  DATA lv_input1 LIKE gv_input.
  DATA lv_input2 LIKE gv_input.

  lv_input1 = scr0101-input.
  lv_input2 = scr0101-input.

  CONDENSE lv_input1.
  CONDENSE lv_input2.

  TRANSLATE lv_input1 TO UPPER CASE. " 대문자로 변경

  IF lv_input1 EQ lv_input2.
    gv_input = lv_input1.
  ELSE.
*   소문자는 허용하지 않습니다. 대문자만 입력하세요.
    MESSAGE e012.
  ENDIF.

ENDFORM.
