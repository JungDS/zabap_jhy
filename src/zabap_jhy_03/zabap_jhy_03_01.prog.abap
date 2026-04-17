*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_01
*&---------------------------------------------------------------------*
*& Checkbox & Radio Button
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_01.


* 항공사ID를 입력할 수 있는 [ 입력필드 ]가 화면에 생성됨( TYPE에 따라 변수의 모양이 달라짐 )
PARAMETERS PA_CAR TYPE SCARR-CARRID DEFAULT 'AA'.

* Selection Screen에서 한 줄 건너띔
  SELECTION-SCREEN SKIP.

* AS CHECKBOX 를 붙이면 [ 체크박스 ]가 화면에 생성됨( 문자 1자리로 변수의 모양이 고정됨 )
PARAMETERS PA_CHK1 AS CHECKBOX.
PARAMETERS PA_CHK2 AS CHECKBOX.

* Selection Screen에서 한 줄 건너띔
  SELECTION-SCREEN SKIP.

* RADIOBUTTON GROUP 그룹명 을 붙이면 [ 라디오버튼 ]이 화면에 생성됨( 문자 1자리로 변수의 모양이 고정됨 )
* 동일한 그룹명을 가진 라디오버튼 중에서 반드시 [ 하나만 ] 선택이 가능하다.
PARAMETERS PA_RB1 RADIOBUTTON GROUP RBG1.
PARAMETERS PA_RB2 RADIOBUTTON GROUP RBG1.
PARAMETERS PA_RB3 RADIOBUTTON GROUP RBG1.

* 체크박스나 라디오버튼은 공통적으로 선택되면 'X', 선택되지 않으면 공백으로 취급된다.

START-OF-SELECTION.

* Parameter는 입력하지 않으면, 공백 그대로, 입력하면 입력한 값 그대로 기록된다.
  WRITE: / '입력필드의 값 :', PA_CAR.

* Checkbox는 각각 개별로 선택여부에 따라 로직을 처리한다.
  IF PA_CHK1 EQ ABAP_ON.
    WRITE / 'PA_CHK1 을 선택했다.'.
  ENDIF.

  IF PA_CHK2 EQ ABAP_ON.
    WRITE / 'PA_CHK2 을 선택했다.'.
  ENDIF.

* Radio Button은 동일한 그룹 내에서 어떤 Radio Button이 선택되었는지 비교하여 특정 로직을 실행한다.
  CASE ABAP_ON.
    WHEN PA_RB1.
      WRITE / 'PA_RB1 를 선택했다.'.
    WHEN PA_RB2.
      WRITE / 'PA_RB2 를 선택했다.'.
    WHEN PA_RB3.
      WRITE / 'PA_RB3 를 선택했다.'.
  ENDCASE.
