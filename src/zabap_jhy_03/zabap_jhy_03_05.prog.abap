*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_05
*&---------------------------------------------------------------------*
*& Selection Screen Line 활용
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_05.


* Selection Screen의 항목들은 생성될 때 새로운 줄의 첫번째 칸에서 생성된다.
SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01.
  PARAMETERS PA_TEST1 AS CHECKBOX.
  PARAMETERS PA_TEST2 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK B01.



* 하지만 이 구역에서는 모든 Selection Screen의 항목들이 전부 한 줄로 출력되며, 중첩 상태는 허용하지 않는다.
SELECTION-SCREEN BEGIN OF BLOCK B02 WITH FRAME TITLE TEXT-T02.
  SELECTION-SCREEN BEGIN OF LINE.             " 줄의 시작
    SELECTION-SCREEN COMMENT 01(30) TEXT-M01. " 01번째 칸에서 넓이 30인 텍스트
    SELECTION-SCREEN COMMENT 41(20) TEXT-M02. " 41번째 칸에서 넓이 20인 텍스트
  SELECTION-SCREEN END OF LINE.               " 줄의 종료
SELECTION-SCREEN END OF BLOCK B02.



* 숫자(숫자) 의 표현은 몇번째 칸부터 얼마나 많은 칸을 사용하느냐, / 가 없으면, 이전 라인의 특정 위치에 출력된다.
SELECTION-SCREEN BEGIN OF BLOCK B03 WITH FRAME TITLE TEXT-T03.
  SELECTION-SCREEN COMMENT    /10(30) TEXT-M03.                     " /를 작성한 Comment
  SELECTION-SCREEN PUSHBUTTON  50(20) TEXT-M04 USER-COMMAND BUTTON. " /가 없는 Button
  SELECTION-SCREEN COMMENT    /10(30) TEXT-M03.                     " /를 작성한 Comment
  SELECTION-SCREEN PUSHBUTTON  50(20) TEXT-M04 USER-COMMAND BUTTON. " /가 없는 Button
SELECTION-SCREEN END OF BLOCK B03.

* POSITION으로 출력위치를 변경할 수 있고, Comment의 For Field를 사용하면 Checkbox의 Text로 출력된다.
SELECTION-SCREEN BEGIN OF BLOCK B04 WITH FRAME TITLE TEXT-T04.
  SELECTION-SCREEN BEGIN OF LINE.
*   LINE 내부에서는 몇번째 칸부터 출력할지 생략하면, 이전 항목의 다음 칸부터 출력한다.
    SELECTION-SCREEN COMMENT (20) TEXT-M05.

*   POSITION에 의해 다음 차례의 항목은 30번째 칸부터 출력
    SELECTION-SCREEN POSITION 30.
    PARAMETERS PA_TEST3 AS CHECKBOX.
    SELECTION-SCREEN COMMENT (15) TEXT-M06.

*   POSITION에 의해 다음 차례의 항목은 50번째 칸부터 출력
    SELECTION-SCREEN POSITION 50.
    PARAMETERS PA_TEST4 AS CHECKBOX.
    SELECTION-SCREEN COMMENT (15) TEXT-M07 FOR FIELD PA_TEST4. " PA_TEST4 를 위한 텍스트로 취급
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B04.
