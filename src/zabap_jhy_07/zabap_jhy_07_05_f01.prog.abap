*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_05_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  " Ranges
  " RANGES 레인지이름 FOR 변수.
  RANGES r_cancelled FOR sbook-cancelled.

* 체크박스 선택 여부에 따라 로직 분기
* 선택   : 취소된 예약과 취소가 안된 예약 모두 검색된다.
*           => 모든 데이터, 조건이 걸리지 않은 모든 데이터
*
* 미선택 : 취소가 안된 예약만 검색된다.
*           => 현재 예약이 유효한 건들만 검색한다.
*           ==> CANCELLED 필드의 값이 'X'인 경우 제외한다.
  IF pa_incan EQ abap_on.
*   선택
    REFRESH r_cancelled.    " <-- 초기화되는 대상은 ?? 바디(Internal Table)
  ELSE.  " 선택이 안되거나
    CLEAR r_cancelled.      " <-- 초기화되는 대상은 ?? 헤더라인(Structure, wa)

    r_cancelled-sign    = 'E'.
    r_cancelled-option  = 'EQ'.
    r_cancelled-low     = 'X'.
    r_cancelled-high    = ''.

    APPEND r_cancelled.     " <<--- 레인지 변수에 한 줄 추가, 즉 조건이 하나 생김
  ENDIF.



  REFRESH gt_data.

  " New Open SQL
  SELECT FROM scarr     AS a
         JOIN spfli     AS b ON b~carrid EQ a~carrid
         JOIN sflight   AS c ON c~carrid EQ a~carrid
                            AND c~connid EQ b~connid
         JOIN sbook     AS d ON d~carrid EQ a~carrid
                            AND d~connid EQ b~connid
                            AND d~fldate EQ c~fldate
         JOIN scustom   AS e ON e~id     EQ d~customid

         FIELDS a~carrid,
                a~carrname,

                b~connid,
                b~countryfr,
                b~countryto,

                c~fldate,
                c~price,
                c~currency,

                d~bookid,
                d~customid,
                e~name AS customname,
                d~order_date,
                d~class,
                d~loccuram,
                d~loccurkey,
                d~smoker,
                d~cancelled

          WHERE a~carrid      EQ @pa_car
            AND b~connid      IN @so_con
            AND c~fldate      IN @so_fld
            AND d~customid    IN @so_cid
            AND d~order_date  IN @so_ord
*            AND D~CANCELLED   NE 'X'
            AND d~cancelled   IN @r_cancelled

           INTO CORRESPONDING FIELDS OF TABLE @gt_data.

***  CL_DEMO_OUTPUT=>DISPLAY( GT_DATA ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .


  REFRESH gt_display.

  LOOP AT gt_data INTO gs_data.

    CLEAR gs_display.
    MOVE-CORRESPONDING gs_data TO gs_display.


    PERFORM set_display_status.
    PERFORM set_display_light.
    PERFORM set_display_color.


    APPEND gs_display TO gt_display.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  DESCRIBE TABLE gt_display.
  MESSAGE s006 WITH sy-tfill. " & 건의 데이터가 검색되었습니다.

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

* 컨테이너 객체부터 먼저 생성한 후
* ALV 객체를 생성할 때 컨테이너 객체를 전달한다.
  CREATE OBJECT go_container
    EXPORTING
      container_name = 'CCON'
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc NE 0.
    MESSAGE e400. " Custom Container 생성 중 오류가 발생했습니다.
  ENDIF.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc <> 0.
    MESSAGE e401. " ALV Grid 생성 중 오류가 발생했습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  CLEAR gs_layout.

* 기본적으로 대부분 적용하는 옵션
  gs_layout-zebra       = abap_on.  " 얼룩처리
  gs_layout-cwidth_opt  = abap_on.  " 열넓이 최적화
  gs_layout-sel_mode    = 'D'.      " 선택모드 => 셀 단위

* 상황에 따라 적용하는 옵션
  gs_layout-excp_fname  = 'LIGHT'.
  gs_layout-excp_led    = abap_on. " 예외처리에서 신호등이 LED 로 변경
  gs_layout-ctab_fname  = 'CELL_COLOR'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

* 아래 두개의 Subroutine을 꼭 확인할 것
  BREAK-POINT.

* 함수를 사용하여 TOP 에 선언한 스트럭쳐를 분석해
* FIELD CATALOG 테이블에 자동으로 데이터가 생성되도록 한다.
  PERFORM get_fieldcat_0100.
  PERFORM make_fieldcat_0100.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM get_fieldcat_0100 .

***  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'

* DATA GT_FIELDCAT TYPE LVC_T_FCAT.
  DATA lt_fieldcat TYPE kkblo_t_fieldcat.

* 초기화
  REFRESH gt_fieldcat.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid      " 현재 프로그램
      i_tabname              = 'GS_DISPLAY'  " FIELDCAT이 필요한 Structure 변수이름
*     I_STRUCNAME            =
      i_inclname             = sy-repid      " 현재 프로그램
      i_bypassing_buffer     = abap_on       " 항상 on
      i_buffer_active        = abap_off      " 항상 off
    CHANGING
      ct_fieldcat            = lt_fieldcat   " KKBLO 로 만들어진 Field Catalog
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  IF sy-subrc EQ 0.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fieldcat " KKBLO
      IMPORTING
        et_fieldcat_lvc   = gt_fieldcat " LVC
      EXCEPTIONS
        it_data_missing   = 1
        OTHERS            = 2.
    IF sy-subrc <> 0.
      MESSAGE e403. " Field Catalog 생성 및 변환 중 오류가 발생했습니다.
    ENDIF.
  ELSE.
    MESSAGE e403. " Field Catalog 생성 및 변환 중 오류가 발생했습니다.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM make_fieldcat_0100 .

* MERGE 함수를 통해 만들어진 Field Catalog는 Dictionary에 정의된
* Semantic Attribute 와 Technical Attribute 가 그대로 기술되어 있다.

* 하지만 프로그램에서 일부 Field 에 대한 속성을 변경하고 싶은 경우
* 이 Subroutines 에서 아래와 같이 변경 후 ALV에게 전달한다.

  LOOP AT gt_fieldcat INTO gs_fieldcat.

    CASE gs_fieldcat-fieldname.
      WHEN 'LIGHT'.
        gs_fieldcat-coltext = '상태'(f01).
      WHEN 'STATUS'.
        gs_fieldcat-coltext = '일정완료여부'(f02).
        gs_fieldcat-just    = 'C'. " L: LEFT, C:CENTER, R:RIGHT
      WHEN 'CARRID'.
*       항공사 ID 는 키필드로 취급되지 않고, 배경색이 진한 초록색이 된다.
        gs_fieldcat-emphasize = 'C510'.
        gs_fieldcat-key       = abap_off.
      WHEN 'SMOKER'.
        gs_fieldcat-checkbox = abap_on. " 체크박스로 변경한다.
      WHEN 'CANCELLED'.
        gs_fieldcat-checkbox = abap_on. " 체크박스로 변경한다.
    ENDCASE.

    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  gs_variant-report = sy-repid.
  gv_save = 'A'.  " 'A':All Both, 'U':User(개인), 'X':Cross(공용)

  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      is_variant      = gs_variant
      i_save          = gv_save
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_display
      it_fieldcatalog = gt_fieldcat
    EXCEPTIONS
      OTHERS          = 1.

  IF sy-subrc NE 0.
    MESSAGE e402. " ALV Grid 에 데이터를 전달하는 중 오류가 발생했습니다.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_DISPLAY_STATUS
*&---------------------------------------------------------------------*
FORM set_display_status .

* 오늘과 같거나 이전이면 비행기는 출발
  IF gs_display-fldate LE sy-datum.
*   아이콘은 SE38 에서 SHOWICON 프로그램을 실행하면 확인가능
    gs_display-status = icon_okay.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_display_light
*&---------------------------------------------------------------------*
FORM set_display_light .


  IF gs_display-cancelled EQ abap_on.
*   취소된 예약건이면 빨간색
    gs_display-light = '1'.
  ELSE.
*   취소가 안된 예약건이면 초록색
    gs_display-light = '3'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_display_color
*&---------------------------------------------------------------------*
FORM set_display_color .

  " Cell 단위 색상 테이블에 사용할 작업공간
  DATA: ls_cell_color LIKE LINE OF gs_display-cell_color.

  " 흡연자일 경우
  IF gs_display-smoker EQ abap_on.
    CLEAR ls_cell_color.

    " 흡연여부 필드에 주황색 배경(C710)으로 표시한다.
    ls_cell_color-fname = 'SMOKER'.
    ls_cell_color-color-col = 7.
    ls_cell_color-color-int = 1.
    ls_cell_color-color-inv = 0.

    INSERT ls_cell_color INTO TABLE gs_display-cell_color.
  ENDIF.


ENDFORM.
