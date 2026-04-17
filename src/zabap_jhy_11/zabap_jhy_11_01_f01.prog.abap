*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_11_01_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_docking
    EXPORTING
      side      = cl_gui_docking_container=>dock_at_bottom     " Side to Which Control is Docked
      extension = 100                                          " Control Extension
    EXCEPTIONS
      OTHERS    = 1.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_docking " Parent Container
    EXCEPTIONS
      OTHERS   = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.
  gs_layout-zebra = abap_on.
  gs_layout-sel_mode = 'D'.

  "# 열최적화는 출력할 데이터가 있을 때 해야한다.
  "# 입력할 때는 데이터가 없는 상태이니 열최적화를 해서는 안된다.
  gs_layout-cwidth_opt = abap_off.
  gs_layout-edit       = abap_off.  " 모든 필드가 편집되도록 여는 옵션

  CALL METHOD go_alv_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1. " 1:수정 모드, 0:조회 모드(기본값)

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

  REFRESH gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SHPCD'.
*  gs_fieldcat-tech      = abap_on. " 기술적 필드로 취급 ( 출력대상에서 완전 제외 )
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MENCD'.
  gs_fieldcat-edit      = abap_off.
  gs_fieldcat-outputlen = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'MENNM'.
  gs_fieldcat-ref_table = 'ZTJHY_MENUT'.
  gs_fieldcat-ref_field = 'MENNM'.
  gs_fieldcat-col_pos   = 4.
  gs_fieldcat-edit      = abap_on.
  gs_fieldcat-outputlen = 20.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'PRICE'.
  gs_fieldcat-cfieldname  = 'WAERS'.
  gs_fieldcat-edit        = abap_on.
  gs_fieldcat-outputlen   = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'WAERS'.
  gs_fieldcat-edit        = abap_off.
  gs_fieldcat-outputlen   = 4.             " 출력길이 설정
  gs_fieldcat-coltext     = '통화'(f08)." 강제로 텍스트 변경하는 법
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'LVORM'.
  gs_fieldcat-checkbox    = abap_on.
  gs_fieldcat-edit        = abap_off.
  gs_fieldcat-outputlen   = 6.             " 출력길이 설정
  gs_fieldcat-coltext     = '단종여부'(f07)." 강제로 텍스트 변경하는 법
  APPEND gs_fieldcat TO gt_fieldcat.

* 생성관련 정보는 입력할 필요 없으니 수정하지 않도록 한다.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ERDAT'.
  gs_fieldcat-edit        = abap_off.
  gs_fieldcat-coltext     = '생성일자'(f01)." 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 12.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ERZET'.
  gs_fieldcat-edit        = abap_off.
  gs_fieldcat-coltext     = '생성시간'(f02)." 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'ERNAM'.
  gs_fieldcat-edit        = abap_off.
  gs_fieldcat-coltext     = '생성자'(f03).  " 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.

* 수정관련 정보는 생성할 때 필요 없으니 숨긴다.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'AEDAT'.
  gs_fieldcat-no_out      = abap_on.
  gs_fieldcat-coltext     = '수정일자'(f04)." 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 12.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'AEZET'.
  gs_fieldcat-no_out      = abap_on.
  gs_fieldcat-coltext     = '수정시간'(f05)." 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'AENAM'.
  gs_fieldcat-no_out      = abap_on.
  gs_fieldcat-coltext     = '수정자'(f06).  " 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 10.             " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
*

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'STATUS'.
  gs_fieldcat-icon        = abap_on.
  gs_fieldcat-coltext     = '상태'(f10).    " 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 6.              " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname   = 'RESULT'.
  gs_fieldcat-ref_table   = 'BAPIRET2'.
  gs_fieldcat-ref_field   = 'MESSAGE'.
  gs_fieldcat-col_pos     = 100.
  gs_fieldcat-coltext     = '결과'(f09).    " 강제로 텍스트 변경하는 법
  gs_fieldcat-outputlen   = 20.              " 출력길이 설정
  APPEND gs_fieldcat TO gt_fieldcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_DISPLAY_0100
*&---------------------------------------------------------------------*
FORM set_alv_display_0100 .

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'ZTJHY_MENU'     " Internal Output Table Structure Name
      is_layout                     = gs_layout        " Layout
    CHANGING
      it_outtab                     = gt_display_menu  " Output Table
      it_fieldcatalog               = gt_fieldcat      " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
FORM init .

  CLEAR ztjhy_shop.
  REFRESH gt_menu.
  REFRESH gt_menu_text.
  REFRESH gt_display_menu.

  gv_complete    = abap_off.
  gv_alv_refresh = abap_on.
  gs_stable-row  = abap_off.
  gs_stable-col  = abap_off.

  CALL METHOD go_alv_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1. " 수정가능하도록 설정

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_ALV_GRID_0100
*&---------------------------------------------------------------------*
FORM refresh_alv_grid_0100 .

  CALL METHOD go_alv_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable " With Stable Rows/Columns
      i_soft_refresh = abap_on.  " Without Sort, Filter, etc.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
FORM save_data .

* 1. 입력된 데이터를 점검한다.
* 2. 저장할 건지 물어본다. ( 먼저 물어보면 기만이 될 수 있음 )
*                            예 누르니깐 너 저장 안되는데? 해버릴 수 있기 때문
*                            물어봐놓고 점검해서 안된다 하면 그게 기만임
* 3. 저장 전 기록할 정보 기록
* 4. 관련된 테이블에 각각 데이터를 저장한다.
* 5. 관련된 테이블에 저장이 모두 성공적이면 확정하고,
*    하나라도 오류가 있으면 취소한다.

*--------------------------------------------------------------------*
* 1. 입력된 데이터를 점검한다.
*--------------------------------------------------------------------*
  PERFORM check_data_for_save.

  IF gv_error EQ abap_on.
    EXIT.
  ENDIF.

*--------------------------------------------------------------------*
* 2. 저장할 건지 물어본다.
*--------------------------------------------------------------------*
  PERFORM confirm_save.

  " 예(J) 눌러야만 진행, 예(1)가 아니면 FORM save_data 중단
  CHECK gv_answer EQ '1'.


*--------------------------------------------------------------------*
* 3. 저장 전 기록할 정보 기록
*--------------------------------------------------------------------*
  PERFORM set_data_before_save.


*--------------------------------------------------------------------*
* 4. 관련된 테이블에 각각 데이터를 저장한다.
*--------------------------------------------------------------------*
  PERFORM insert_record.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_DATA_FOR_SAVE
*&---------------------------------------------------------------------*
FORM check_data_for_save .

  " 점검용 필드, 여기에 X가 들어가면 이후 로직을 실행하지 않는다.
  CLEAR gv_error.

  DATA  lv_valid.


*--------------------------------------------------------------------*
* 저장하기 전에 꼭 호출해야 하는 중요한 메소드!!
*--------------------------------------------------------------------*
  " ALV에 입력된 내용 중 이상한 건 없는지 점검과
  " ALV에 입력된 내용을 연결된 Internal Table에도 반영
  CALL METHOD go_alv_grid->check_changed_data
    IMPORTING
      e_valid = lv_valid.  " Entries are Consistent.

  IF lv_valid IS INITIAL.
    gv_error = abap_on.
    " ALV에 기록된 데이터가 오류가 있습니다.
    MESSAGE i000 WITH TEXT-m01.
    EXIT.
  ENDIF.

  IF gt_display_menu IS INITIAL.
    " 등록된 메뉴가 하나도 없으면 가게 정보를 등록할 수 없습니다.
    MESSAGE i000 WITH TEXT-m02.
    gv_error = abap_on.
    EXIT.
  ENDIF.



  IF gv_error EQ abap_off.
*--------------------------------------------------------------------*
* 메뉴정보도 올바른지 점검해야 한다.
*--------------------------------------------------------------------*
    FIELD-SYMBOLS <fs_wa> LIKE gs_display_menu.
    LOOP AT gt_display_menu ASSIGNING <fs_wa>.

      <fs_wa>-status = icon_yellow_light.
      <fs_wa>-result = space.

      PERFORM check_data USING <fs_wa>
                               gv_error.

    ENDLOOP.

    " 오류가 없었는데, 생겼다면, ALV에 기록된 오류내용을 화면에 출력한다.
    IF gv_error EQ abap_on.
      " & 가(이) 유효하지 않습니다.
      MESSAGE i013 DISPLAY LIKE 'E' WITH '메뉴정보'(l03).
      gv_alv_refresh = abap_on.
    ENDIF.

  ENDIF.


*  LOOP AT gt_display_menu INTO gs_display_menu.
*
*    IF gs_display_menu-mennm IS INITIAL.
*      " # 번째 메뉴명이 공란입니다.
*      MESSAGE i000 WITH sy-tabix
*                        TEXT-m03.
*      gv_error = abap_on.
*      EXIT.
*    ENDIF.
*
*    IF gs_display_menu-price IS INITIAL.
*      " # 번째 메뉴의 가격정보가 없습니다.
*      MESSAGE i000 WITH sy-tabix
*                        TEXT-m04.
*      gv_error = abap_on.
*      EXIT.
*    ENDIF.
*
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CONFIRM_SAVE
*&---------------------------------------------------------------------*
FORM confirm_save .

  DATA lv_title TYPE string.
  DATA lv_text1 TYPE string.

  lv_title = TEXT-m05. " 안내
  lv_text1 = TEXT-m06. " 신규 가게 정보를 등록하시겠습니까?

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = lv_title         " Title of dialog box
      text_question         = lv_text1         " Question text in dialog box
      display_cancel_button = abap_off         " Button for displaying cancel pushbutton
    IMPORTING
      answer                = gv_answer.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DATA_BEFORE_SAVE
*&---------------------------------------------------------------------*
FORM set_data_before_save .

*--------------------------------------------------------------------*
* Header의 가게번호 채번 ( Number Range 없이 )
*--------------------------------------------------------------------*
  SELECT FROM ztjhy_shop
         FIELDS MAX( shpcd )
         INTO @ztjhy_shop-shpcd.

  IF sy-subrc EQ 0.
    ztjhy_shop-shpcd = ztjhy_shop-shpcd + 1.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ztjhy_shop-shpcd  " C field
      IMPORTING
        output = ztjhy_shop-shpcd.  " Internal display of INPUT, any category
  ELSE.
    ztjhy_shop-shpcd = '0001'.
  ENDIF.

*--------------------------------------------------------------------*
* Header의 생성정보 기록
*--------------------------------------------------------------------*
  ztjhy_shop-erdat = sy-datum.
  ztjhy_shop-erzet = sy-uzeit.
  ztjhy_shop-ernam = sy-uname.


*--------------------------------------------------------------------*
* Items의 메뉴번호 채번
*--------------------------------------------------------------------*

  REFRESH gt_menu.
  REFRESH gt_menu_text.

  LOOP AT gt_display_menu INTO gs_display_menu.

    " 메뉴의 가게번호도 동일하게 지정한다.
    gs_display_menu-shpcd = ztjhy_shop-shpcd.

    " 메뉴의 메뉴번호는 순서대로 지정한다.
    gs_display_menu-mencd = sy-tabix.

    gs_display_menu-erdat = sy-datum.
    gs_display_menu-erzet = sy-uzeit.
    gs_display_menu-ernam = sy-uname.

    MODIFY gt_display_menu FROM gs_display_menu
                           TRANSPORTING shpcd
                                        mencd
                                        erdat
                                        erzet
                                        ernam.

    CLEAR gs_menu.
    gs_menu = CORRESPONDING #( gs_display_menu ).
    APPEND gs_menu TO gt_menu.

    CLEAR gs_menu_text.
    gs_menu_text = CORRESPONDING #( gs_display_menu ).
    gs_menu_text-spras = sy-langu.
    APPEND gs_menu_text TO gt_menu_text.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING po_data_changed TYPE REF TO cl_alv_changed_data_protocol
                                po_sender       TYPE REF TO cl_gui_alv_grid.

  DATA(lt_ins) = po_data_changed->mt_inserted_rows.

  " 신규라인에 대해서
  " STATUS필드에 노란 신호등,
  " WAERS필드에 'KRW'를 기록한다.
  LOOP AT lt_ins INTO DATA(ls_ins).

    CALL METHOD po_data_changed->modify_cell
      EXPORTING
        i_row_id    = ls_ins-row_id    " Row ID
        i_fieldname = 'STATUS'         " Field Name
        i_value     = icon_yellow_light.  " Value

    CALL METHOD po_data_changed->modify_cell
      EXPORTING
        i_row_id    = ls_ins-row_id    " Row ID
        i_fieldname = 'WAERS'          " Field Name
        i_value     = gc_waers_krw.    " Value

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_telno
*&---------------------------------------------------------------------*
FORM check_telno .

  DATA: lv_success.

  CHECK ztjhy_shop-telno IS NOT INITIAL.

  CALL FUNCTION 'Z_ABAP_JHY_11_CHECK_TELNO'
    EXPORTING
      iv_number  = ztjhy_shop-telno " 전화번호
    IMPORTING
      ev_success = lv_success.      " 점검결과(X:성공)

  CHECK lv_success IS INITIAL.

  CLEAR ok_code.

  " & 가(이) 유효하지 않습니다.
  MESSAGE e013 WITH '전화번호'(l02).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PSTCD
*&---------------------------------------------------------------------*
FORM check_pstcd .

  DATA: lv_success.

  CHECK ztjhy_shop-pstcd IS NOT INITIAL.

  CALL FUNCTION 'Z_ABAP_JHY_11_CHECK_PSTCD'
    EXPORTING
      iv_postal_code = ztjhy_shop-pstcd " 우편번호
    IMPORTING
      ev_success     = lv_success.      " 점검결과(X:성공)

  CHECK lv_success IS INITIAL.

  CLEAR ok_code.

  " & 가(이) 유효하지 않습니다.
  MESSAGE e013 WITH '우편번호'(l03).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_event_0100
*&---------------------------------------------------------------------*
FORM set_alv_event_0100 .

  CALL METHOD go_alv_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified " Event ID
    EXCEPTIONS
      error      = 1                " Error
      OTHERS     = 2.

  SET HANDLER lcl_event_handler=>on_data_changed FOR go_alv_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSERT_RECORD
*&---------------------------------------------------------------------*
FORM insert_record .

  DATA lv_subrc TYPE sy-subrc.


*--------------------------------------------------------------------*
* Header 테이블에 데이터 기록
*--------------------------------------------------------------------*
*  INSERT dbtab FROM wa(스트럭쳐변수).
*  INSERT ZTJHY_shop from ZTJHY_shop.
  INSERT ztjhy_shop.

  " 실행결과를 lv_subrc에 합산
  ADD sy-subrc TO lv_subrc.

*--------------------------------------------------------------------*
* Item 테이블에 데이터 기록
*--------------------------------------------------------------------*
  INSERT ztjhy_menu FROM TABLE gt_menu.

  " 실행결과를 lv_subrc에 합산
  ADD sy-subrc TO lv_subrc.

*--------------------------------------------------------------------*
* Item의 텍스트 테이블에 데이터 기록
*--------------------------------------------------------------------*
  INSERT ztjhy_menut FROM TABLE gt_menu_text.

  " 실행결과를 lv_subrc에 합산
  ADD sy-subrc TO lv_subrc.


  " LV_SUBRC가 0이라면 모든 실행결과가 0인 것이므로,
  " 이 때만 레코드 생성을 확정처리 하고,
  " 만약 0이 아니라면 레코드 생성을 원복(Rollback) 한다.
  IF lv_subrc EQ 0.
    COMMIT WORK.
    " TEXT-M09 : 가게 정보가 올바르게 등록되었습니다.
    MESSAGE s000 WITH TEXT-m09.

    " ALV에도 변경된 내용 최신화
    LOOP AT gt_display_menu INTO gs_display_menu.
      gs_display_menu-status = icon_green_light.
      gs_display_menu-result = '생성완료'(m07).
      MODIFY gt_display_menu FROM gs_display_menu.
    ENDLOOP.

    FIELD-SYMBOLS <fs_wa> LIKE gs_display_menu.
    LOOP AT gt_display_menu ASSIGNING <fs_wa>.
      <fs_wa>-status = icon_green_light.
      <fs_wa>-result = '생성완료'(m07).
    ENDLOOP.

    " 생성완료 표시( 입력필드 잠그는 용도 )
    gv_complete = abap_on.

    CALL METHOD go_alv_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 0. " ALV를 읽기전용으로 변경

  ELSE.
    ROLLBACK WORK.
    " TEXT-M10 : 가게 정보 등록 중 오류가 발생했습니다.
    MESSAGE s000 DISPLAY LIKE 'E' WITH TEXT-m10.

    " 임시 부여했던 가게번호 초기화
    ztjhy_shop-shpcd = space.

    " ALV에도 변경된 내용 최신화
    LOOP AT gt_display_menu INTO gs_display_menu.
      gs_display_menu-status = icon_red_light.
      gs_display_menu-shpcd  = space.
      gs_display_menu-result = '생성실패'(m08).
      MODIFY gt_display_menu FROM gs_display_menu.
    ENDLOOP.

  ENDIF.

  gv_alv_refresh = abap_on.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_data
*&---------------------------------------------------------------------*
*& USING 뒤에 VALUE 가 없으므로, Call by reference 방식이다.
*& value 를 사용해서 쓰는 Call by Value, Call by Value and Result
*&---------------------------------------------------------------------*
**FORM A USING PV_VALUE.  " Call by reference
**
**ENDFORM.
**FORM A CHANGING PV_VALUE.  " Call by reference
**
**ENDFORM.
**FORM A USING VALUE(PV_VALUE).  " Call by value
**
**ENDFORM.
**FORM A CHANGING VALUE(PV_VALUE).  " Call by value and result
**
**ENDFORM.
FORM check_data  USING ps_menu  LIKE gs_display_menu
                       pv_error.

  IF ps_menu-mennm IS INITIAL.
    " # 번째 메뉴명이 공란입니다.
    ps_menu-status = icon_red_light.
    ps_menu-result = sy-tabix && TEXT-m03.
    pv_error = abap_on.
  ENDIF.

  IF ps_menu-price IS INITIAL.
    " # 번째 메뉴의 가격정보가 없습니다.
    ps_menu-status = icon_red_light.
    ps_menu-result = sy-tabix && TEXT-m04.
    pv_error = abap_on.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_OBJ_0120
*&---------------------------------------------------------------------*
FORM init_obj_0120 .

  CHECK go_ccon_0120 IS INITIAL.

  PERFORM create_object_0120.
  PERFORM set_html_event_0120.
  PERFORM show_html_0120.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_popup
*&---------------------------------------------------------------------*
FORM create_object_popup .

  CREATE OBJECT go_dialog
    EXPORTING
      width   = 520               " Width of This Container
      height  = 250              " Height of This Container
      repid   = sy-repid         " Report to Which This Control is Linked
      dynnr   = '0100'           " Screen to Which the Control is Linked
      top     = 5                " Top Position of Dialog Box
      left    = 30               " Left Position of Dialog Box
      caption = '우편번호'       " Dialog Box Caption
    EXCEPTIONS
      OTHERS  = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CREATE OBJECT go_html_popup
    EXPORTING
      parent = go_dialog  " Container
    EXCEPTIONS
      OTHERS = 1.


  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_html_event_popup
*&---------------------------------------------------------------------*
FORM set_html_event_popup .

  DATA lt_event TYPE cntl_simple_events.
  DATA ls_event TYPE cntl_simple_event.

  ls_event-eventid    = go_html_popup->m_id_sapevent.
  ls_event-appl_event = 'X'.
  APPEND ls_event TO lt_event.

  CALL METHOD go_html_popup->set_registered_events
    EXPORTING
      events = lt_event.


  SET HANDLER lcl_event_handler=>on_close    FOR go_dialog.
  SET HANDLER lcl_event_handler=>on_sapevent FOR go_html_popup.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form show_html_popup
*&---------------------------------------------------------------------*
FORM show_html_popup .

  DATA lv_url TYPE url_path.

  " SMW0에 등록된 HTML 파일 정보를 가져온다.
  CALL METHOD go_html_popup->load_html_document
    EXPORTING
      document_id  = 'ZABAP_JHY_11_01'     " Document ID
    IMPORTING
      assigned_url = lv_url                 " URL
    EXCEPTIONS
      OTHERS       = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



* HTML 정보를 화면에 출력
  CALL METHOD go_html_popup->show_url
    EXPORTING
      url    = lv_url            " URL
*     frame  =                  " frame where the data should be shown
*     in_place               = ' X'             " Is the document displayed in the GUI?
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_0120
*&---------------------------------------------------------------------*
FORM create_object_0120 .

  CREATE OBJECT go_ccon_0120
    EXPORTING
      container_name = 'CCON_0120'.


  CREATE OBJECT go_html
    EXPORTING
      parent = go_ccon_0120  " Container
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_html_event_0120
*&---------------------------------------------------------------------*
FORM set_html_event_0120 .

  DATA lt_event TYPE cntl_simple_events.
  DATA ls_event TYPE cntl_simple_event.


  ls_event-eventid    = go_html->m_id_sapevent.
  ls_event-appl_event = 'X'.

  APPEND ls_event TO lt_event.

  CALL METHOD go_html->set_registered_events
    EXPORTING
      events = lt_event.

  SET HANDLER lcl_event_handler=>on_sapevent FOR go_html.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form show_html_0120
*&---------------------------------------------------------------------*
FORM show_html_0120 .

  DATA lv_url TYPE url_path.

  " SMW0에 등록된 HTML 파일 정보를 가져온다.
  CALL METHOD go_html->load_html_document
    EXPORTING
      document_id  = 'ZABAP_JHY_11_01'     " Document ID
    IMPORTING
      assigned_url = lv_url                 " URL
    EXCEPTIONS
      OTHERS       = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



* HTML 정보를 화면에 출력
  CALL METHOD go_html->show_url
    EXPORTING
      url    = lv_url            " URL
*     frame  =                  " frame where the data should be shown
*     in_place               = ' X'             " Is the document displayed in the GUI?
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
