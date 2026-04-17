*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

  " itab 초기화 => 한 줄도 없는 완전히 비어있는 상태로 만듦
  REFRESH GT_PFLI.

  " Database Table에서 데이터를 가져오는 방법
  SELECT * FROM SPFLI
    INTO TABLE GT_PFLI
   WHERE CARRID IN SO_CAR
     AND CONNID IN SO_CON
     AND COUNTRYFR IN SO_CTRF
     AND COUNTRYTO IN SO_CTRT.

  " itab의 데이터를 정렬하는 방법
  SORT GT_PFLI BY CARRID
                  CONNID.


  REFRESH GT_CARR.
  SELECT * FROM SCARR INTO TABLE GT_CARR.
  SORT GT_CARR BY CARRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM MAKE_DISPLAY_DATA .

  " itab GT_PFLI 에서 화면에 데이터를 출력하기 위한
  " itab GT_DISPLAY 로 데이터를 복사 전달한다.

  REFRESH GT_DISPLAY. " 어차피 비어 있겠지만, 그래도 사용하기 전에
  " 항상 깔끔하게 초기화하는 습관을 들이는 것이 좋다.

  " Database 에서 가져온 데이터를 GT_PFLI에 보관했는데,
  " 그 데이터를 한줄씩 GT_DISPLAY 에 append 한다. ( append => 한줄씩 추가 )
  LOOP AT GT_PFLI INTO GS_PFLI.
    CLEAR GS_DISPLAY. " 항상 사용하기 전에 초기화하는 습관
    MOVE-CORRESPONDING GS_PFLI TO GS_DISPLAY. " 이거 모르면, 아래 처럼 써야함.

    GS_DISPLAY-CARRID = GS_PFLI-CARRID.
    GS_DISPLAY-CONNID = GS_PFLI-CONNID.
    GS_DISPLAY-COUNTRYFR = GS_PFLI-COUNTRYFR.
    GS_DISPLAY-COUNTRYTO = GS_PFLI-COUNTRYTO.
    " 이렇게 쓰다 보면 결국엔 뭔가 하나씩 빼먹는 경우가 자주 생김.
    " 그래서 MOVE-CORRESPONDING 같은 키워드를 잘 활용해야만 한다.

    " GS_DISPLAY 에 필드에 적절한 값을 전부 채우면
    " GT_DISPLAY 에 APPEND 한다.

    APPEND GS_DISPLAY TO GT_DISPLAY. " <--- GT_DISPLAY 에 한줄이 늘어난다.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .

  " itab 을 분석하면 몇 줄이나 있는지 SY-TFILL 에 보관된다.
  " SY-TFILL 을 외우는게 어려우면 그냥 변수를 선언해서 그 변수에 보관해도 된다.
  DESCRIBE TABLE GT_DISPLAY.

  DATA LV_I TYPE I.
  DESCRIBE TABLE GT_DISPLAY LINES LV_I.
  " 이 방법을 쓰면 SY-TFILL 을 안써도 LV_I 에 itab 이 몇줄이나 있는지 알 수 있다.

  " ZMSG_E00의 006의 메세지는 [ & 건의 데이터가 검색되었습니다. ] 이다.
  MESSAGE S006 WITH SY-TFILL.
  MESSAGE S006 WITH LV_I.


  " 위의 과정들이 어느 정도 마무리되면 이제 100 번 화면을 호출해서
  " 데이터를 보여주는 작업을 시작하면 된다.
  CALL SCREEN 0100.

**  사실 간단하게 itab 내용을 확인하고 싶으면 아래처럼 임시로 테스트해볼 수 있다.
*  CL_DEMO_OUTPUT=>WRITE_DATA(
*    VALUE   = GT_PFLI
*    NAME    = '항공편 정보'
*  ).
*
*  CL_DEMO_OUTPUT=>WRITE_DATA(
*    VALUE   = GT_DISPLAY
*    NAME    = '출력용 데이터'
*  ).
*
*  CL_DEMO_OUTPUT=>DISPLAY( ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

* Container 부터 객체를 생성하고, 그 뒤에 ALV Grid 객체를 생성한다.

  CREATE OBJECT GO_CONTAINER
    EXPORTING
      CONTAINER_NAME              = 'CCON' " Name of CustCtrl on the Screen to Link Container
    EXCEPTIONS
      CNTL_ERROR                  = 1 " CNTL_ERROR
      CNTL_SYSTEM_ERROR           = 2 " CNTL_SYSTEM_ERROR
      CREATE_ERROR                = 3 " CREATE_ERROR
      LIFETIME_ERROR              = 4 " LIFETIME_ERROR
      LIFETIME_DYNPRO_DYNPRO_LINK = 5 " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
*   400: Custom Container 생성 중 오류가 발생했습니다.
    MESSAGE E400. " 오류 타입으로 메시지 출력해서 화면에 보여주고, 프로그램을 중단 ( 오류 메시지 특징 )
  ENDIF.

  " Container 가 정상적으로 생성이 되었다면,
  " 그 다음에는 Container 위에 보여질 ALV 를 생성한다.
  CREATE OBJECT GO_ALV_GRID
    EXPORTING
      I_PARENT          = GO_CONTAINER " Parent Container
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1 " Error when creating the control
      ERROR_CNTL_INIT   = 2 " Error While Initializing Control
      ERROR_CNTL_LINK   = 3 " Error While Linking Control
      ERROR_DP_CREATE   = 4 " Error While Creating DataProvider Control
      OTHERS            = 5.

  IF SY-SUBRC <> 0.
*   401: ALV Grid 생성 중 오류가 발생했습니다.
    MESSAGE E401. " 오류 타입의 메시지를 출력 => 프로그램 중단
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT_0100 .

  CLEAR GS_LAYOUT.

  " ALV 에게 전달하는 itab 의 필드 중 ROW_COLOR 라는 필드는
  " 데이터를 취급하는 게 아니라 한 줄에 대한 색상 정보를 취급하는
  " 특별한 필드라는 사실을 전달할 수 있게
  " INFO_FNAME 에 'ROW_COLOR' 라는 문자열을 기록한다.

  GS_LAYOUT-INFO_FNAME = 'MY_ROW_COLOR'.
  GS_LAYOUT-STYLEFNAME = 'MY_STYLE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT_0100 .

  REFRESH GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MY_CHKBOX'.
  GS_FIELDCAT-CHECKBOX  = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

  CLEAR GS_FIELDCAT.
  GS_FIELDCAT-FIELDNAME = 'MY_ICON'.
  GS_FIELDCAT-ICON      = ABAP_ON.
  APPEND GS_FIELDCAT TO GT_FIELDCAT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM SET_ALV_EVENT_0100 .
  " 이 참조변수가 앞서서 이미 생성이 되었었는지 모르므로
  " IS INITIAL 인 상태일 때만 CREATE OBJECT 를 통해 생성하도록 한다.
  IF GO_EVENT_HANDLER IS INITIAL.
    CREATE OBJECT GO_EVENT_HANDLER.
  ENDIF.

  SET HANDLER : " 핸들러 메소드를 등록하기 위한 키워드

    " ALV 만을 위한 ON_DOUBLE_CLICK 메소드를 등록해둔다.
    " 단, 이 메소드는 DOUBLE_CLICK 이벤트에만 반응한다.
    GO_EVENT_HANDLER->ON_DOUBLE_CLICK FOR GO_ALV_GRID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_0100 .

  " ALV 가 화면에 컬럼( FIELD CATALOG ) 과 행 ( DATA , itab ) 으로
  " 데이터를 출력하기 위한 메소드를 호출한다.
  CALL METHOD GO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      I_STRUCTURE_NAME              = 'SPFLI'          " Internal Output Table Structure Name
*     IS_VARIANT                    =                  " Layout
*     I_SAVE                        =                  " Save Layout
      IS_LAYOUT                     = GS_LAYOUT        " Layout
    CHANGING
      IT_OUTTAB                     = GT_DISPLAY       " Output Table
*     IT_FIELDCATALOG               =                  " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE E023. " 에러 메세지
  ENDIF.

ENDFORM.
