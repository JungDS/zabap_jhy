*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_04
*&---------------------------------------------------------------------*
*& Field Symbol 동적 활용 예시 2
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_04.

DATA: BEGIN OF gs_data,
        field01 TYPE char10,
        field02 TYPE char10,
        field03 TYPE char10,
        field04 TYPE char10,
        field05 TYPE char10,
        field06 TYPE char10,
      END OF gs_data.

FIELD-SYMBOLS <fs> TYPE char10.

START-OF-SELECTION.


* 첫번째부터 여섯번째 필드를 모두 한줄씩 출력한다.
  gs_data-field01 = 1.
  gs_data-field02 = 2.
  gs_data-field03 = 3.
  gs_data-field04 = 4.
  gs_data-field05 = 5.
  gs_data-field06 = 6.

  WRITE: / 'FIELD01:', gs_data-field01,
         / 'FIELD02:', gs_data-field02,
         / 'FIELD03:', gs_data-field03,
         / 'FIELD04:', gs_data-field04,
         / 'FIELD05:', gs_data-field05,
         / 'FIELD06:', gs_data-field06.

  skip 2.


  DO 6 TIMES.

*   <FS>가   첫번째 반복일 때, GS_DATA의   첫번째 필드에 접근한다.
*   <FS>가   두번째 반복일 때, GS_DATA의   두번째 필드에 접근한다.
*   <FS>가   세번째 반복일 때, GS_DATA의   세번째 필드에 접근한다.
*   <FS>가   네번째 반복일 때, GS_DATA의   네번째 필드에 접근한다.
*   <FS>가 다섯번째 반복일 때, GS_DATA의 다섯번째 필드에 접근한다.
*   <FS>가 여섯번째 반복일 때, GS_DATA의 여섯번째 필드에 접근한다.
    ASSIGN COMPONENT sy-index OF STRUCTURE gs_data TO <fs>.

*   동적으로 연결될 때는 항상 SY-SUBRC 가 0인지 검사해서 ASSIGN 여부를 확인한다.
    CHECK sy-subrc EQ 0.

*   접근한 N번째 필드에 자신의값 * 100의 결과를 기록한다.
    <fs> = <fs> * 100.

*   목적을 다했을 때는 항상 필드심볼은 UNASSIGN으로 더이상 변수를 가리키지 않도록 한다.
    UNASSIGN <fs>.
  ENDDO.


* 첫번째부터 여섯번째 필드를 모두 한줄씩 출력한다.
  ULINE.
  WRITE: / '직접 필드 하나하나 출력하기'.
  ULINE.
  WRITE: / 'FIELD01:', gs_data-field01,
         / 'FIELD02:', gs_data-field02,
         / 'FIELD03:', gs_data-field03,
         / 'FIELD04:', gs_data-field04,
         / 'FIELD05:', gs_data-field05,
         / 'FIELD06:', gs_data-field06.
  skip 2.

* 첫번째부터 여섯번째 필드를 모두 한줄씩 출력한다.
  ULINE.
  WRITE: / 'Field Symbol로 동적접근하여 출력하기'.
  ULINE.
  DO 6 TIMES.
    ASSIGN COMPONENT sy-index OF STRUCTURE gs_data TO <fs>.
    WRITE: / |FIELD{ CONV numc2( sy-index ) }:|,<fs>.
  ENDDO.
