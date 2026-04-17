*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_book_agg.

  SELECT FROM sbook
         FIELDS carrid,
                left( fldate, 6 ),
                SUM( loccuram ),
                loccurkey
         WHERE carrid IN @so_car
           AND connid IN @so_con
           AND fldate BETWEEN @gv_fldate_s AND @gv_fldate_e
           AND cancelled EQ @space
         GROUP BY carrid, loccurkey, left( fldate, 6 )
         INTO TABLE @gt_book_agg.

  SELECT carrid, carrname FROM scarr INTO TABLE @DATA(gt_carr).

  SORT gt_carr BY carrid.

  SORT gt_book_agg BY spmon carrid.

  LOOP AT gt_book_agg INTO gs_book_agg.

    READ TABLE gt_carr INTO DATA(ls_carr) WITH KEY carrid = gs_book_agg-carrid BINARY SEARCH.
    CHECK sy-subrc EQ 0.

    gs_book_agg-forcurkey = 'USD'.

    CALL FUNCTION 'SAPBC_GLOBAL_FOREIGN_CURRENCY'
      EXPORTING
        local_amount     = gs_book_agg-loccuram
        local_currency   = gs_book_agg-loccurkey   " Initial currency
        foreign_currency = gs_book_agg-forcurkey   " Target Currency
      IMPORTING
        foreign_amount   = gs_book_agg-forcuram.

    gs_book_agg-carrname = ls_carr-carrname.
    MODIFY gt_book_agg FROM gs_book_agg TRANSPORTING carrname forcuram forcurkey.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_container
    EXPORTING
      container_name = 'CCON'.

  CREATE OBJECT go_chart_engine
    EXPORTING
      parent = go_container.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_CHART_EVENT_0100
*&---------------------------------------------------------------------*
FORM set_chart_event_0100 .

  IF go_event_handler IS INITIAL.
    CREATE OBJECT go_event_handler.
  ENDIF.

  SET HANDLER go_event_handler->on_click FOR go_chart_engine.
  SET HANDLER go_event_handler->on_value_change FOR go_chart_engine.
  SET HANDLER go_event_handler->on_property_change FOR go_chart_engine.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_CHART_DATA_0100
*&---------------------------------------------------------------------*
FORM set_chart_data_0100 .

  DATA: lo_ixml_doc TYPE REF TO if_ixml_document,
        lo_ostream  TYPE REF TO if_ixml_ostream,
        lv_xstr     TYPE xstring.

  lo_ostream = go_ixml_sf->create_ostream_xstring( lv_xstr ).

  PERFORM create_data USING lo_ixml_doc.
  CALL METHOD lo_ixml_doc->render EXPORTING ostream = lo_ostream.

  go_chart_engine->set_data( xdata = lv_xstr ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form create_data
*&---------------------------------------------------------------------*
FORM create_data USING p_ixml_doc TYPE REF TO if_ixml_document.

  DATA: l_simplechartdata TYPE REF TO if_ixml_element,
        l_categories      TYPE REF TO if_ixml_element,
        l_series          TYPE REF TO if_ixml_element,
        l_element         TYPE REF TO if_ixml_element,
        l_encoding        TYPE REF TO if_ixml_encoding.

  p_ixml_doc = go_ixml->create_document( ).

  l_encoding = go_ixml->create_encoding( byte_order    = if_ixml_encoding=>co_little_endian
                                         character_set = 'utf-8' ).
  p_ixml_doc->set_encoding( l_encoding ).

  l_simplechartdata = p_ixml_doc->create_simple_element( name   = 'SimpleChartData'
                                                         parent = p_ixml_doc ).
  l_categories = p_ixml_doc->create_simple_element( name   = 'Categories'
                                                    parent = l_simplechartdata ).

  gt_carr = CORRESPONDING #( gt_book_agg ).
  SORT gt_carr BY carrid carrname.
  DELETE ADJACENT DUPLICATES FROM gt_carr COMPARING carrid.

  data lv_tabix type i.

  LOOP AT gt_carr INTO gs_carr.
    lv_tabix = sy-tabix.

    gs_carr-series = p_ixml_doc->create_simple_element( name = 'Series' parent = l_simplechartdata ).
    gs_carr-series->set_attribute( name = 'label'       value = CONV #( gs_carr-carrname ) ).

*--------------------------------------------------------------------*
* 첫번째 컬럼은 시리즈 Series1 을 적용
* 두번째 컬럼은 시리즈 Series2 를 적용
*--------------------------------------------------------------------*
    case lv_tabix.
      when 1.
        gs_carr-series->set_attribute( name = 'customizing' value = 'Series1' ).
      when 2.
        gs_carr-series->set_attribute( name = 'customizing' value = 'Series2' ).
      when OTHERS.
    endcase.

    MODIFY gt_carr FROM gs_carr TRANSPORTING series.
  ENDLOOP.


  DATA lv_spmon TYPE spmon.

  lv_spmon = gv_fldate_s(6).

  WHILE lv_spmon <= gv_fldate_e(6).

    l_element = p_ixml_doc->create_simple_element( name = 'C' parent = l_categories ).
    l_element->if_ixml_node~set_value( |{ lv_spmon(4) }.{ lv_spmon+4(2) }| ).

    LOOP AT gt_carr INTO gs_carr.
      CLEAR gs_book_agg.
      READ TABLE gt_book_agg  INTO gs_book_agg  WITH KEY  spmon = lv_spmon
                                                          carrid = gs_carr-carrid
                                                          BINARY SEARCH.

      p_ixml_doc->create_simple_element(
        name = 'S'
        parent = gs_carr-series
      )->if_ixml_node~set_value(
        |{ gs_book_agg-forcuram CURRENCY = gs_book_agg-forcurkey }|
      ).
    ENDLOOP.

    IF lv_spmon+4(2) EQ '12'.
      lv_spmon+0(4) = lv_spmon(4) + 1.
      lv_spmon+4(2) = '01'.
    ELSE.
      lv_spmon += 1.
    ENDIF.
  ENDWHILE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_CHART_CUSTOM_0100
*&---------------------------------------------------------------------*
FORM set_chart_custom_0100 .


  DATA: lo_ixml_doc TYPE REF TO if_ixml_document,
        lo_ostream  TYPE REF TO if_ixml_ostream,
        lv_xstr     TYPE xstring.


  CLEAR lv_xstr.
  lo_ostream = go_ixml_sf->create_ostream_xstring( lv_xstr ).

  PERFORM create_custom USING lo_ixml_doc.
  CALL METHOD lo_ixml_doc->render EXPORTING ostream = lo_ostream.

  go_chart_engine->set_customizing( xdata = lv_xstr ).

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  create_custom
*&---------------------------------------------------------------------*
FORM create_custom USING p_ixml_doc TYPE REF TO if_ixml_document.

  DATA: l_root           TYPE REF TO if_ixml_element,
        l_globalsettings TYPE REF TO if_ixml_element,
        l_default        TYPE REF TO if_ixml_element,
        l_elements       TYPE REF TO if_ixml_element,
        l_chartelements  TYPE REF TO if_ixml_element,
        l_title          TYPE REF TO if_ixml_element,
        l_values         TYPE REF TO if_ixml_element,
        l_series         TYPE REF TO if_ixml_element,
        l_element        TYPE REF TO if_ixml_element,
        l_encoding       TYPE REF TO if_ixml_encoding.


  p_ixml_doc = go_ixml->create_document( ).
  l_encoding = go_ixml->create_encoding( byte_order    = if_ixml_encoding=>co_little_endian
                                         character_set = 'utf-8' ).
  p_ixml_doc->set_encoding( l_encoding ).

  l_root = p_ixml_doc->create_simple_element( parent = p_ixml_doc name = 'SAPChartCustomizing' ).
  l_root->set_attribute( name = 'version' value = '1.1' ).

*--------------------------------------------------------------------*
* GlobalSettings
*--------------------------------------------------------------------*
  l_globalsettings = p_ixml_doc->create_simple_element( parent = l_root name = 'GlobalSettings' ).

  p_ixml_doc->create_simple_element( parent = l_globalsettings:
                                     name   = 'FileType'    )->if_ixml_node~set_value( 'PNG' ),
                                     name   = 'Dimension'   )->if_ixml_node~set_value( 'PseudoThree' ),
                                     name   = 'Width'       )->if_ixml_node~set_value( '640' ),
                                     name   = 'Height'      )->if_ixml_node~set_value( '360' ).


  l_default = p_ixml_doc->create_simple_element( parent = l_globalsettings
                                                 name   = 'Defaults' ).
  l_element = p_ixml_doc->create_simple_element( parent = l_default
                                                 name   = 'FontFamily' ).
  l_element->if_ixml_node~set_value( 'Arial' ).


*--------------------------------------------------------------------*
* Elements
*--------------------------------------------------------------------*
  l_elements      = p_ixml_doc->create_simple_element( parent = l_root name = 'Elements' ).
  l_chartelements = p_ixml_doc->create_simple_element( parent = l_elements name = 'ChartElements' ).
  l_title         = p_ixml_doc->create_simple_element( parent = l_chartelements name = 'Title' ).
  p_ixml_doc->create_simple_element( parent = l_title:
                                     name   = 'Extension' )->if_ixml_node~set_value( 'href="sapevent:onclick?Title"' ),
                                     name   = 'Caption'   )->if_ixml_node~set_value( CONV #( TEXT-t01 ) ).

  data(lo_title_text) = p_ixml_doc->create_simple_element( parent = l_title name = 'Text' ).
  data(lo_title_size) = p_ixml_doc->create_simple_element( parent = lo_title_text name = 'Size' value = '30' ).

*--------------------------------------------------------------------*
* Values - 시리즈를 만들고 해당 시리즈를 참조할 때 특정 컬러가 적용되도록 한다.
*--------------------------------------------------------------------*
  l_values      = p_ixml_doc->create_simple_element( parent = l_root   name = 'Values' ).
  l_series      = p_ixml_doc->create_simple_element( parent = l_values name = 'Series' ).
  l_series->set_attribute( name  = 'id'
                           value = 'Series1' ).
  p_ixml_doc->create_simple_element( parent = l_series
                                     name   = 'Color'   )->if_ixml_node~set_value( 'RGB(60,248,80)' ).


  l_series      = p_ixml_doc->create_simple_element( parent = l_values name = 'Series' ).
  l_series->set_attribute( name  = 'id'
                           value = 'Series2' ).
  p_ixml_doc->create_simple_element( parent = l_series
                                     name   = 'Color'   )->if_ixml_node~set_value( 'RGB(248,80,60)' ).



ENDFORM. " create_custom_demo

*&---------------------------------------------------------------------*
*&      Form  toggle_design_mode
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM toggle_design_mode .

  DATA: l_win_chart       TYPE REF TO cl_gui_chart_engine_win.

  CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
    l_win_chart ?= go_chart_engine->get_control( ).
  ENDCATCH.
  IF sy-subrc IS INITIAL.

    IF g_design_mode IS INITIAL.
      g_design_mode = 'X'.
    ELSE.
      g_design_mode = ' '.
    ENDIF.

    l_win_chart->set_design_mode( flag = g_design_mode event = 'X' ).
    l_win_chart->restrict_chart_types( charttypes = 'Columns|Lines' ).
    l_win_chart->restrict_property_events( events = 'ChartType' ).

  ENDIF.

ENDFORM. " toggle_design_mode

*&---------------------------------------------------------------------*
*&      Form  toggle_value_change
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM toggle_value_change .

  DATA: l_win_chart       TYPE REF TO cl_gui_chart_engine_win.

  CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
    l_win_chart ?= go_chart_engine->get_control( ).
  ENDCATCH.
  IF sy-subrc IS INITIAL.

    IF g_value_change IS INITIAL.
      g_value_change = 'X'.

      l_win_chart->enable_value_change( ).
    ELSE.
      g_value_change = ' '.

      l_win_chart->disable_value_change( ).
    ENDIF.

  ENDIF.

ENDFORM. " toggle_value_change

*&---------------------------------------------------------------------*
*&      Form  save_customizing
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM save_customizing .

  DATA: l_xml_customizing TYPE w3mimetabtype,
        l_win_chart       TYPE REF TO cl_gui_chart_engine_win,
        l_filename        TYPE string,
        l_filepath        TYPE string,
        l_filesize        TYPE i,
        l_path            TYPE string.

  CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
    l_win_chart ?= go_chart_engine->get_control( ).
  ENDCATCH.
  IF sy-subrc IS INITIAL.

    l_win_chart->get_customizing(
      IMPORTING
        xdata_table = l_xml_customizing
    ).
    DESCRIBE TABLE l_xml_customizing LINES l_filesize.
    MULTIPLY l_filesize BY 255.

    l_filename = 'customizing.xml'.
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        default_file_name = l_filename
      CHANGING
        filename          = l_filename
        path              = l_path
        fullpath          = l_filepath.

    IF NOT l_filepath IS INITIAL.
      CALL METHOD cl_gui_frontend_services=>gui_download
        EXPORTING
          filetype         = 'BIN'
          filename         = l_filepath
          bin_filesize     = l_filesize
        CHANGING
          data_tab         = l_xml_customizing
        EXCEPTIONS
          file_write_error = 1
          OTHERS           = 22.
    ENDIF.

  ENDIF.

ENDFORM. " save_customizing

*&---------------------------------------------------------------------*
*&      Form  print
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM print .

  DATA: l_win_chart       TYPE REF TO cl_gui_chart_engine_win.

  CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
    l_win_chart ?= go_chart_engine->get_control( ).
  ENDCATCH.
  IF sy-subrc IS INITIAL.

    l_win_chart->print( ).

  ENDIF.

ENDFORM. " print
*&---------------------------------------------------------------------*
*& Form set_period
*&---------------------------------------------------------------------*
FORM set_period .

  gv_fldate_s = so_spmon-low && '01'.
  IF so_spmon-high IS INITIAL.
    gv_fldate_e = gv_fldate_s.
  ELSE.
    gv_fldate_e = so_spmon-high && '01'.
  ENDIF.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = gv_fldate_e                 " Key date
    IMPORTING
      last_day_of_month = gv_fldate_e.                 " Date of last day of the month from key  date


ENDFORM.
