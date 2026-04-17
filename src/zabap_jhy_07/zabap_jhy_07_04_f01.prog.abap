*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_04_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_data.

  " SFLIGHT 에서 특정 필드만 선택해서 데이터를 가져와
  " itab 의 필드가 동일한 경우만 값을 기록한다.
  SELECT carrid,
         connid,
         fldate,
         price,
         currency,
         seatsmax,
         seatsocc,
         paymentsum
*  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
   WHERE carrid EQ @pa_car.  " <-- Selection Screen에서 입력받은 항공사ID와
  "     동일한 항공사ID를 지닌 데이터만 검색s

  SORT gt_data BY carrid
                  connid
                  fldate.


  " Database Table       SCARR 에서 데이터를 검색해서
  " Dictionary Structure SCARR 로   저장
  " SCARR 끼리 이름이 똑같으니깐 반복 느낌이 나서 생략이 가능하다.
  SELECT SINGLE *
    FROM scarr
   WHERE carrid EQ pa_car.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .

  DATA ls_style TYPE lvc_s_styl. " GS_DISPLAY-STYLE 의 작업공간

  REFRESH gt_display.

  " GT_DATA 의 데이터를 GT_DISPLAY 로 옮긴다.
  " 옮기는 중 추가로 작업할 내용들도 같이 기록한다.
  LOOP AT gt_data INTO gs_data.

    CLEAR gs_display.
    MOVE-CORRESPONDING gs_data TO gs_display. " 동일한 필드명에게 값 전달

    " 내일부터 출발하는 비행기들은 취소가 가능하도록 버튼을 생성함.
    IF gs_display-fldate > sy-datum.
      gs_display-cancel_bttxt = TEXT-l01. " 일정 취소.

      " CANCEL_BTTXT 라는 필드는 스타일을 버튼으로 취급하는 정보를
      " Internal Table인 GS_DISPLAY-STYLE 에 한 줄 추가한다.
      CLEAR ls_style.
      ls_style-fieldname = 'CANCEL_BTTXT'.
      ls_style-style     = cl_gui_alv_grid=>mc_style_button.
      APPEND ls_style TO gs_display-style.
    ENDIF.

    " GS_DATA 와 그리고 내일부터 출발하는 비행기들만 CANCEL_BTTXT 필드와
    " STYLE 필드에 특별한 값들이 저장된 GS_DISPLAY 를 GT_DISPLAY 로 한 줄 추가한다.
    APPEND gs_display TO gt_display.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  " MESSAGE-ID ZMSG_E00 로 등록이 되어 있어야만 한다.
  " 006: & 건의 데이터가 검색되었습니다.

  DESCRIBE TABLE gt_display.  " SY-TFILL
  MESSAGE s006 WITH sy-tfill. " & 건의 데이터가 검색되었습니다.


  DATA lv_i TYPE i.
  DESCRIBE TABLE gt_display LINES lv_i.
  MESSAGE s006 WITH lv_i.     " & 건의 데이터가 검색되었습니다.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_container
    EXPORTING
      container_name = 'CCON' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  CASE sy-subrc.
    WHEN 0.
      " 정상
    WHEN 1.
      " Custom Container 생성 중 오류가 발생했습니다.
      MESSAGE e400.
  ENDCASE.


  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent          = go_container  " Parent Container
    EXCEPTIONS
      error_cntl_create = 1 " Error when creating the control
      error_cntl_init   = 2 " Error While Initializing Control
      error_cntl_link   = 3 " Error While Linking Control
      error_dp_create   = 4 " Error While Creating DataProvider Control
      OTHERS            = 5.

  IF sy-subrc NE 0.
    " ALV Grid 생성 중 오류가 발생했습니다.
    MESSAGE e401.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.

  gs_layout-zebra = abap_on. " 얼룩 처리

  gs_layout-cwidth_opt = abap_on. " 열넓이 최적화

  gs_layout-sel_mode = 'D'. " 선택 모드 => 셀단위 (D)

  gs_layout-grid_title = TEXT-t02. " 비행일정

  gs_layout-stylefname = 'STYLE'. " <-- GT_DISPLAY 의 필드 중 STYLE 이라는 필드는
  "     ALV 의 스타일 을 담당하는 필드로 취급한다.

*  GS_LAYOUT-INFO_FNAME " itab 의 필드 중 행 색상을 담당하는 필드는 어느 필드인가?
*  GS_LAYOUT-EXCP_FNAME " itab 의 필드 중 상태(신호등) 아이콘을 표현하는 필드는 어느 필드인가?
*  GS_LAYOUT-CTAB_FNAME " itab 의 필드 중 셀 색상을 담당하는 필드는 어느 필드인가?


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

  REFRESH gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-col_pos   = 10.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  gs_fieldcat-ref_field = ''.         " 적지 않는 이유는 동일하면 생략이 가능하기 때문에
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-col_pos   = 20.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  gs_fieldcat-ref_field = 'CONNID'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'FLDATE'.
  gs_fieldcat-col_pos   = 30.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'PRICE'.
  gs_fieldcat-col_pos   = 40.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  gs_fieldcat-cfieldname = 'CURRENCY'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CURRENCY'.
  gs_fieldcat-col_pos   = 50.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSMAX'.
  gs_fieldcat-col_pos   = 60.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSOCC'.
  gs_fieldcat-col_pos   = 70.
  gs_fieldcat-ref_table = 'SFLIGHT'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CANCEL_BTTXT'.
  gs_fieldcat-col_pos   = 80.
  gs_fieldcat-outputlen = 10.
  gs_fieldcat-coltext   = TEXT-f01. " 취소 버튼
  gs_fieldcat-just      = 'C'.      " 가운데 정렬
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
*     I_STRUCTURE_NAME              =                  " Internal Output Table Structure Name
*     IS_VARIANT                    =                  " Layout
*     I_SAVE                        =                  " Save Layout
      is_layout                     = gs_layout         " Layout
    CHANGING
      it_outtab                     = gt_display        " Output Table
      it_fieldcatalog               = gt_fieldcat       " Field Catalog
*     IT_SORT                       =                  " Sort Criteria
*     IT_FILTER                     =                  " Filter Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    MESSAGE e402. " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM set_alv_event_0100 .

  " Static Method 이므로, 클래스=>메소드 로 표현할 수 있다.
  SET HANDLER lcl_event_handler=>on_button_click FOR go_alv_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_BUTTON_CLICK_CANCEL
*&---------------------------------------------------------------------*
FORM handle_button_click_cancel USING VALUE(ps_row_no) TYPE lvc_s_roid.

  DATA lv_msg TYPE string.

  " 현재 선택하신 버튼은 &1 번째 줄의 &2 열 입니다.
  " &1 = ES_ROW_NO-ROW_ID     = 내가 선택한 버튼의 행 위치
  " &2 = ES_COL_ID-FIELDNAME  = 내가 선택한 버튼의 열 위치
*        LV_MSG = '현재 선택하신 버튼은' && ES_ROW_NO-ROW_ID && '번째 줄의' && ES_COL_ID-FIELDNAME && ' 열 입니다.'.
*        LV_MSG = |현재 선택하신 버튼은 { ES_ROW_NO-ROW_ID } 번째 줄의 { ES_COL_ID-FIELDNAME } 열 입니다.|.
*        MESSAGE LV_MSG TYPE 'I'.

  DATA lv_answer TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'N'                                           " Positioning the cursor on answer yes or no
      textline1      = TEXT-m01         " 예약을 취소하시겠습니까?   " first line of dialog box
*     textline2      = space                                         " second line of dialog box
      titel          = TEXT-t03         " 확인                       " Title line of dialog box
*     start_column   = 25                                            " Start column of the dialog box
*     start_row      = 6                                             " Start line of the dialog box
      cancel_display = space                                         " Display cancel button
    IMPORTING
      answer         = lv_answer.                                    " selected answer of end user

*        LV_MSG = '내가 선택한 버튼의 값은' && LV_ANSWER && ' 이다.'.
*        MESSAGE LV_MSG TYPE 'I'.

  CASE lv_answer.
    WHEN 'J'. " Yes 예 버튼 눌렀을 때

      " ES_ROW_NO-ROW_ID : 내가 버튼을 누른 행 번호
      " GT_DISPLAY 에서 내가 누른 버튼이 있는 행을 삭제하겠다.
      DELETE gt_display INDEX ps_row_no-row_id.

      DATA ls_stable TYPE lvc_s_stbl.

      ls_stable-row = abap_on. " 'X'  현재 행의 위치에 여전히 머무르겠다.
      ls_stable-col = abap_on. " 'X'  현재 열의 위치에 여전히 머무르겠다.

      CALL METHOD go_alv_grid->refresh_table_display
        EXPORTING
          is_stable = ls_stable " With Stable Rows/Columns
*         I_SOFT_REFRESH =                  " Without Sort, Filter, etc.
*              EXCEPTIONS
*         FINISHED  = 1                " Display was Ended (by Export)
*         OTHERS    = 2
        .

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
