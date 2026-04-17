*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_06_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
FORM init .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_1000
*&---------------------------------------------------------------------*
FORM modify_screen_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND_1000
*&---------------------------------------------------------------------*
FORM user_command_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  CLEAR   gv_lines.
  REFRESH gt_carr.

  SELECT FROM scarr
         FIELDS *
         WHERE carrid   IN @s_carrid
           AND carrname IN @s_carrnm
           AND currcode IN @s_currcd
         INTO CORRESPONDING FIELDS OF TABLE @gt_carr.

  IF sy-subrc EQ 0.
    gv_lines = sy-dbcnt.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .

  REFRESH gt_display.

  LOOP AT gt_carr INTO gs_carr.

    CLEAR gs_display.
    MOVE-CORRESPONDING gs_carr TO gs_display.
    gs_display = CORRESPONDING #( gs_carr ).


    APPEND gs_display TO gt_display.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  IF gt_display[] IS INITIAL.
    " 데이터를 찾을 수 없습니다.
    MESSAGE s008 DISPLAY LIKE gc_msgty_warning.
  ELSE.
    " & 건의 데이터가 검색되었습니다.
    MESSAGE s006 WITH gv_lines.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
FORM create_object .

  CREATE OBJECT go_container
    EXPORTING
      container_name = gc_custctrl_name " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT
*&---------------------------------------------------------------------*
FORM set_alv_layout .

  CLEAR gs_variant.
  CLEAR gs_layout.

  gs_variant-report  = sy-repid. " 단독 프로그램 실행 시 SY-CPROG 로 대체 가능
  gs_variant-handle = ''.        " ALV가 단독일 경우 공백도 무방
* GS_VARIANT-HANDLE = 'ALV1'.    " 2개 이상의 ALV가 존재할 경우( 모든 Screen 포함 )

  gv_save            = gc_variant_save_mode_all.

  gs_layout-sel_mode    = 'D'.
  gs_layout-cwidth_opt  = abap_on.
  gs_layout-zebra       = abap_on.

*  DATA GS_LAYOUT TYPE LVC_S_LAYO.
*
*  GS_LAYOUT-SEL_MODE   = 'D'.       " 'A' or 'B' or 'C' or 'D'
*  GS_LAYOUT-CWIDTH_OPT = 'X'.       " 'X' or '' : 열 최적화 적용 여부(데이터가 많을 경우 속도 저하)
*  GS_LAYOUT-ZEBRA      = 'X'.       " 'X' or '' : 행 줄무늬(Striped Pattern) 여부
*  GS_LAYOUT-EDIT       = ' '.       " 'X' or '' : 전체 편집 여부
*  GS_LAYOUT-GRID_TITLE = '제목'.    " 문자열    : 제목
*  GS_LAYOUT-SMALLTITLE = ' '.       " 'X' or '' : 글꼴 크기를 줄인 제목 출력 여부
*  GS_LAYOUT-NO_HEADERS = ' '.       " 'X' or '' : 필드명 숨김 여부
*  GS_LAYOUT-NO_MERGING = ' '.       " 'X' or '' : 정렬 합병 여부
*  GS_LAYOUT-NO_HGRIDLN = ' '.       " 'X' or '' : 수평선 숨김 여부
*  GS_LAYOUT-NO_VGRIDLN = ' '.       " 'X' or '' : 수직선 숨김 여부
*  GS_LAYOUT-NO_ROWMARK = ' '.       " 'X' or '' : 행 선택 버튼 숨김 여부
*  GS_LAYOUT-NO_ROWMOVE = ' '.       " 'X' or '' : 수정 모드에서 행 이동 금지 여부
*  GS_LAYOUT-NO_ROWINS  = ' '.       " 'X' or '' : 수정 모드에서 행 추가,삭제 금지 여부
*  GS_LAYOUT-NO_TOOLBAR = ' '.       " 'X' or '' : ALV 상단의 Toolbar 숨김 여부( 숨길 경우 모든 버튼 미출력 )
*  GS_LAYOUT-TOTALS_BEF = ' '.       " 'X' or '' : 합계라인 상단 배치 여부
*  GS_LAYOUT-BOX_FNAME  = '필드명'.  " 문자열    : 행 선택 버튼을 누른 경우 'X'값이 기록될 필드 지정
*  GS_LAYOUT-STYLEFNAME = '필드명'.  " 문자열    : 셀 스타일 연동용 필드(CHAR1) 지정
*  GS_LAYOUT-INFO_FNAME = '필드명'.  " 문자열    : 행 색상 연동용 필드(CHAR4) 지정
*  GS_LAYOUT-CTAB_FNAME = '필드명'.  " 문자열    : 셀 색상 연동용 필드(LVC_T_SCOL) 지정
*  GS_LAYOUT-EXCP_FNAME = '필드명'.  " 문자열    : 상태 연동용 필드(CHAR1) 지정
*  GS_LAYOUT-EXCP_LED   = ' '.       " 'X' or '' : 상태를 신호등이 아닌 LED 아이콘으로 변경
*  GS_LAYOUT-KEYHOT     = ' '.       " 'X' or '' : 모든 키 필드에 HOTSPOT 적용 여부

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM set_alv_display_data .


  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'SCARR'          " Internal Output Table Structure Name
      is_variant                    = gs_variant       " Layout
      i_save                        = gv_save          " Save Layout
      i_default                     = 'X'              " Default Display Variant
      is_layout                     = gs_layout        " Layout
    CHANGING
      it_outtab                     = gt_display       " Output Table
      it_fieldcatalog               = gt_fieldcat      " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat .

  DATA ls_fieldcat LIKE LINE OF gt_fieldcat.

  REFRESH gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRID'.
  ls_fieldcat-coltext   = '항공사ID'(f01).
  ls_fieldcat-just      = gc_text_align_center.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRNAME'.
  ls_fieldcat-coltext   = '항공사명'(f02).
  ls_fieldcat-emphasize = gc_color_green_light.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CURRCODE'.
  ls_fieldcat-coltext   = '통화코드'(f03).
  ls_fieldcat-just      = gc_text_align_center.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'URL'.
  ls_fieldcat-coltext   = '웹페이지'(f04).
  APPEND ls_fieldcat TO gt_fieldcat.

ENDFORM.
