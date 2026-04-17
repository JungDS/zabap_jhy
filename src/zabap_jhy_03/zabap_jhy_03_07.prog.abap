*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_07
*&---------------------------------------------------------------------*
*& Tabstrip 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_07.


DATA GS_SPFLI TYPE SPFLI.

" Tabstrip에 첫번째 Tab의 Subscreen으로 사용된다.
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
  SELECT-OPTIONS: SO_CAR FOR GS_SPFLI-CARRID,
                  SO_CON FOR GS_SPFLI-CONNID.
SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
  " 문자 40자를 보관할 수 있는 변수 TEXT_01 이 선언됨.
  SELECTION-SCREEN COMMENT 1(40) TEXT_01.
SELECTION-SCREEN END OF SCREEN 102.


* 1000 번 화면에서 Tabstrip을 추가하고, 이 Tabstrip은
" Subscreen 101번과 102번을 Tabpage 로 사용한다.
SELECTION-SCREEN BEGIN OF TABBED BLOCK TAB_B01 FOR 3 LINES.
  SELECTION-SCREEN TAB (20) TAB_T1 USER-COMMAND TAB_CLICK_1 DEFAULT SCREEN 101.
  SELECTION-SCREEN TAB (20) TAB_T2 USER-COMMAND TAB_CLICK_2 DEFAULT SCREEN 102.
SELECTION-SCREEN END OF BLOCK TAB_B01.

INITIALIZATION.
  TEXT_01 = '102번 SUBSCREEN에서만 보이는 문자열입니다.'.
  TAB_T1  = '첫번째 탭의 제목'.
  TAB_T2  = '두번째 탭의 제목'.

  " 탭스트립의 시작 탭을 첫번째 탭이 아니라 두번째 탭으로 설정
  " TAB_B01: SELECTION-SCREEN BEGIN OF TABBED BLOCK 으로 정한 탭스트립의 이름
  TAB_B01-ACTIVETAB = 'TAB_CLICK_2'." 시작탭이 두번째 탭으로 변경
  TAB_B01-DYNNR     = 102.          " 시작탭 페이지가 SUBSCREEN 102로 변경

  " SELECT-OPTIONS 인 SO_CAR에 초기값을 설정함
  " 설정된 초기값은 [ AA 부터 LH 까지, AZ는 제외 ]
  CLEAR SO_CAR.
  SO_CAR-SIGN   = 'I'.
  SO_CAR-OPTION = 'BT'.
  SO_CAR-LOW    = 'AA'.
  SO_CAR-HIGH   = 'LH'.
  APPEND SO_CAR.

  CLEAR SO_CAR.
  SO_CAR-SIGN   = 'E'.
  SO_CAR-OPTION = 'EQ'.
  SO_CAR-LOW    = 'AZ'.
  APPEND SO_CAR.

START-OF-SELECTION.

  CASE TAB_B01-ACTIVETAB.

    WHEN 'TAB_CLICK_1'.
      WRITE / '첫번째 탭에서 프로그램이 실행되었습니다.'.

    WHEN 'TAB_CLICK_2'.
      WRITE / '두번째 탭에서 프로그램이 실행되었습니다.'.

  ENDCASE.
