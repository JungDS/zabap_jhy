*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_02_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

* Selection Screen 에서는 SPFLI 의 데이터를 조회하기 위해
* Carrid 와 Connid 에 해당하는 조건값을 입력받는다.

  REFRESH gt_pfli.

  SELECT *
    FROM spfli
    INTO TABLE gt_pfli
   WHERE carrid IN so_car
     AND connid IN so_con
   ORDER BY PRIMARY KEY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .

* GT_PFLI     에 보관된 검색결과를 ALV로 출력하기 위한
* GT_DISPLAY  에 옮기면서 출력될 아이콘 모양도 결정한다.

  REFRESH gt_display.

  DATA ls_pfli LIKE LINE OF gt_pfli.

  LOOP AT gt_pfli INTO ls_pfli.

    CLEAR gs_display.

    " Fill GS_DISPLAY
    MOVE-CORRESPONDING ls_pfli TO gs_display.

    IF gs_display-countryfr EQ gs_display-countryto.
      gs_display-status = icon_incoming_object.
    ELSE.
      gs_display-status = icon_outgoing_object.
    ENDIF.

    APPEND gs_display TO gt_display.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  " GT_DISPLAY를 분석해서 SY-TFILL에 라인 수를 기록한다.
  DESCRIBE TABLE gt_display.

  " & 건의 데이터가 검색되었습니다.
  MESSAGE s006 WITH sy-tfill.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_container " 화면의 커스텀 컨트롤과 연결
    EXPORTING
      container_name = 'CCON'.

  CREATE OBJECT go_alv_grid  " 참조변수인 컨테이너와 연결
    EXPORTING
      i_parent = go_container.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      it_outtab        = gt_display
      it_fieldcatalog  = gt_fieldcat
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc NE 0.
    " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
    MESSAGE e023(zmsg_e00).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCATALOG_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcatalog_0100 .

  REFRESH gt_fieldcat.

*   신규 <- Database SPFLI 에 없는 필드
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'STATUS'.
  gs_fieldcat-col_pos   = 4.          " 3번째로 출력한다. 왜? COL_POS = 1 은 [ MANDT ]가 차지하지만 숨김 상태
  gs_fieldcat-icon      = abap_on.
  gs_fieldcat-coltext   = TEXT-f01.   " Category
  APPEND gs_fieldcat TO gt_fieldcat.


  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'FLTYPE'.
  gs_fieldcat-checkbox  = abap_on.    " 화면에 CHECKBOX 로 보이도록 변경
  gs_fieldcat-outputlen = 12.         " 출력길이 => 컬럼의 넓이를 12칸으로 조정
  APPEND gs_fieldcat TO gt_fieldcat.


  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-hotspot   = abap_on.    " 마우스로 클릭 가능하게 속성 변경
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-hotspot   = abap_on.    " 마우스로 클릭 가능하게 속성 변경
  APPEND gs_fieldcat TO gt_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM set_alv_event_0100 .

* Event Handler 객체 생성
  IF go_event_handler IS INITIAL.
    CREATE OBJECT go_event_handler.
  ENDIF.

* ALV Grid인 GO_ALV_GRID에 Event Handler Method인 [ ON_HOTSPOT_CLICK ]을 등록한다.
  SET HANDLER go_event_handler->on_hotspot_click FOR go_alv_grid.

ENDFORM.
