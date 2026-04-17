*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_06
*&---------------------------------------------------------------------*
*& Selection Screen 다중 생성 및 호출
*&---------------------------------------------------------------------*
REPORT zabap_jhy_03_06.



*--------------------------------------------------------------------*
* 이 Parameter들은 Selection Screen 1000 화면에 생성된다.
*--------------------------------------------------------------------*
PARAMETERS pa_ra1 RADIOBUTTON GROUP rag1.
PARAMETERS pa_ra2 RADIOBUTTON GROUP rag1.

*--------------------------------------------------------------------*
* 이 Parameter들은 Selection Screen 1100 화면에 생성된다.
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 1100.
  PARAMETERS: pa_car TYPE spfli-carrid.
  PARAMETERS: pa_con TYPE spfli-connid.
SELECTION-SCREEN END OF SCREEN 1100.

*--------------------------------------------------------------------*
* 이 Parameter들은 Selection Screen 1200 화면에 생성된다.
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 1200.
  SELECT-OPTIONS: so_car FOR pa_car.
  SELECT-OPTIONS: so_con FOR pa_con.
SELECTION-SCREEN END OF SCREEN 1200.
*--------------------------------------------------------------------*


*--------------------------------------------------------------------*
* SELECT-OPTIONS 선언 시 FOR 뒤에는 변수만 기록해야 한다.
*--------------------------------------------------------------------*
* SO의 Low필드, High필드의 타입과 길이가 기록된 변수와 동일하게 선언된다.
* - SIGN    필드: 문자 1자리,      검색결과 포함/제외를 의미하며 'I' 또는 'E' 만 취급
* - OPTION  필드: 문자 2자리,      비교방법으로 EQ,NE,GT,GE,LT,LE,BT,NB 등 다양한 유형을 취급
* - LOW     필드: FOR 변수로 결정, 검색조건의 하한값
* - HIGH    필드: FOR 변수로 결정, 검색조건의 상한값
*--------------------------------------------------------------------*
* 예) SIGN = I, OPTION = BT, LOW = AA , HIGH = LH =>> AA부터 LH까지 범위검색결과를 포함한다.
*     SIGN = E, OPTION = EQ, LOW = DL             =>> DL과 동일한 검색결과는 제외한다.
*--------------------------------------------------------------------*



INITIALIZATION.
  " 프로그램 실행 시 최초로 실행되는 이벤트 구간
  " 주로 변수의 초기값을 설정하는데 사용된다.
  pa_ra2 = abap_on. " 라디오버튼 2이 선택되도록 한다.

START-OF-SELECTION.

  " 현재 화면이 화면번호 1000 인 경우만 진행
  CHECK sy-dynnr EQ 1000.

  " 현재 화면이 화면번호 1000 이 아니면 중단한다.
  IF sy-dynnr NE 1000.
    EXIT.
  ENDIF.

  CASE abap_on.
    WHEN pa_ra1.
      CALL SELECTION-SCREEN 1100.
      IF sy-subrc EQ 0.
        MESSAGE '실행버튼을 누름' TYPE 'I'.
      ELSE.
        MESSAGE '현재 화면을 종료' TYPE 'I'.
      ENDIF.
    WHEN pa_ra2.
      CALL SELECTION-SCREEN 1200 STARTING AT 10 10.
      IF sy-subrc EQ 0.
        MESSAGE '실행버튼을 누름' TYPE 'I'.
      ELSE.
        MESSAGE '현재 화면을 종료' TYPE 'I'.
      ENDIF.
  ENDCASE.
