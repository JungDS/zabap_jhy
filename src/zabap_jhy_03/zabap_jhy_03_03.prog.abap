*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_03
*&---------------------------------------------------------------------*
*& Selection Screen Pushbutton
*&---------------------------------------------------------------------*
REPORT zabap_jhy_03_03.

TABLES sscrfields.
DATA gv_count TYPE i VALUE 1.

SELECTION-SCREEN PUSHBUTTON /1(20) buttxt USER-COMMAND click.

AT SELECTION-SCREEN OUTPUT.
  buttxt = gv_count.
  CONDENSE buttxt. " 앞뒤 공백 제거

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'CLICK'.
      " 푸시버튼을 눌렀을 때인 것을 구별할 수 있다.
      gv_count = gv_count + 1.
  ENDCASE.
