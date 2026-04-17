*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_00
*&---------------------------------------------------------------------*
*& Call Transaction Using BDC Data
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_00 MESSAGE-ID zabap_jhy_msg.


TABLES sscrfields.


DATA gt_bdcdata TYPE TABLE OF bdcdata.
DATA gs_bdcdata TYPE bdcdata.


* TEXT-S01: 실행 조건
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

  SELECTION-SCREEN BEGIN OF BLOCK b02.
*   테이블 또는 프로그램을 선택하기 위한 라디오 버튼
    PARAMETERS pa_rb1   RADIOBUTTON GROUP rbg1 USER-COMMAND radio_btn_click.
    PARAMETERS pa_rb2   RADIOBUTTON GROUP rbg1.

    SELECTION-SCREEN SKIP.

*   실행 시 필요한 정보
    PARAMETERS pa_tname TYPE dd02l-tabname    MODIF ID tnm MEMORY ID dtb.
    PARAMETERS pa_pname TYPE reposrc-progname MODIF ID pnm MEMORY ID rid.

  SELECTION-SCREEN END OF BLOCK b02.

  SELECTION-SCREEN SKIP.

* BDC 옵션을 위한 Parameters
  PARAMETERS pa_mode  TYPE ctu_params-dismode MODIF ID pnm OBLIGATORY.
  PARAMETERS pa_nobin TYPE ctu_params-nobinpt MODIF ID pnm.
  PARAMETERS pa_nobie TYPE ctu_params-nobiend MODIF ID pnm.
  PARAMETERS pa_defsi TYPE ctu_params-defsize MODIF ID pnm.

SELECTION-SCREEN END OF BLOCK b01.


INITIALIZATION.

* Selection Screen의 Parameters 초기값 설정
  PERFORM init_data_1000.


AT SELECTION-SCREEN OUTPUT.

* Selection Screen 요소의 화면옵션 조정
  PERFORM modify_screen_1000.


AT SELECTION-SCREEN ON BLOCK b02.

* Selection Screen Block B02 기준으로 점검
  PERFORM check_input_1000.


START-OF-SELECTION.

* 프로그램 실행 시 라디오 버튼에 따라 SE11 또는 SE38 이 실행된다. 이때, 테이블 이름과 프로그램 이름을 자동으로 살펴볼 수 있다.
  CASE abap_on.
    WHEN pa_rb1.
      PERFORM call_transaction_se11 USING pa_tname.
    WHEN pa_rb2.
      PERFORM call_transaction_se38 USING pa_pname.
  ENDCASE.


*&---------------------------------------------------------------------*
*& Form INIT_DATA_1000
*&---------------------------------------------------------------------*
FORM init_data_1000 .

* Selection Screen을 위한 초기값 설정
  pa_rb1    = abap_on.
  pa_rb2    = abap_off.
  pa_mode   = 'A'.
  pa_nobin  = abap_on.
  pa_defsi  = abap_on.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_1000
*&---------------------------------------------------------------------*
FORM modify_screen_1000 .

* 라디오 버튼에 따라, 화면의 요소가 출력되거나 숨겨진다.
  CASE abap_on.
    WHEN pa_rb1.

      LOOP AT SCREEN.
        CASE screen-group1.
          WHEN 'TNM'.
            screen-required = 2.
          WHEN 'PNM'.
            screen-active = 0.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.

    WHEN pa_rb2.

      LOOP AT SCREEN.
        CASE screen-group1.
          WHEN 'TNM'.
            screen-active = 0.
          WHEN 'PNM'.
            screen-required = 2.
        ENDCASE.
        MODIFY SCREEN.
      ENDLOOP.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_INPUT_1000
*&---------------------------------------------------------------------*
FORM check_input_1000 .

* Selection Screen에서 실행버튼을 눌렀을 때만 진행
  CHECK sscrfields-ucomm EQ 'ONLI'.

* 라디오 버튼에 따라 입력필드의 값을 구별해서 점검
  CASE abap_on.
    WHEN pa_rb1.
      CHECK pa_tname IS INITIAL.
    WHEN pa_rb2.
      CHECK pa_pname IS INITIAL.
  ENDCASE.

* 필수 입력필드가 공란입니다.
  MESSAGE e010.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_TRANSACTION_SE11
*&---------------------------------------------------------------------*
FORM call_transaction_se11 USING pv_tname TYPE dd02l-tabname.

* SE11 에서 MARA 테이블을 조회하기 위한 BDC Data
* ┌─────────────────┬────────┬──────────┬───────────────────┬────────────────┐
* │ PROGRAM         │ DYNPRO │ DYNBEGIN │ FNAM              │ FVAL           │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────┤
* │ 'SAPLSD_ENTRY'  │ '0100' │ 'X'      │                   │                │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────┤
* │                 │        │          │ 'RSRD1-TBMA_VAL'  │ 'MARA'         │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────┤
* │                 │        │          │ 'BDC_OKCODE'      │ '=WB_DISPLAY'  │
* └─────────────────┴────────┴──────────┴───────────────────┴────────────────┘

  REFRESH gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-program  = 'SAPLSD_ENTRY'.
  gs_bdcdata-dynpro   = '1000'.
  gs_bdcdata-dynbegin = abap_on.
  APPEND gs_bdcdata TO gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-fnam     = 'RSRD1-TBMA_VAL'.
  gs_bdcdata-fval     = pv_tname.
  APPEND gs_bdcdata TO gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-fnam     = 'BDC_OKCODE'.
  gs_bdcdata-fval     = '=WB_DISPLAY'.
  APPEND gs_bdcdata TO gt_bdcdata.

  CALL TRANSACTION 'SE11' USING gt_bdcdata MODE 'E'.

* MODE 에 대한 옵션 설명
* - A : GT_BDCDATA의 과정을 모두 보여줌
* - E : GT_BDCDATA의 마지막 과정까지 끝난 모습 OR
*       GT_BDCDATA의 과정 중 오류가 발생한 모습
* - N : Background, 화면에 안보임

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CALL_TRANSACTION_SE38
*&---------------------------------------------------------------------*
FORM call_transaction_se38 USING pv_pname TYPE reposrc-progname.

* SE38 에서 YABAP_JHY_07_01 프로그램을 조회하기 위한 BDC Data
* ┌─────────────────┬────────┬──────────┬───────────────────┬────────────────────┐
* │ PROGRAM         │ DYNPRO │ DYNBEGIN │ FNAM              │ FVAL               │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────────┤
* │ 'SAPLWBABAP'    │ '0100' │ 'X'      │                   │                    │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────────┤
* │                 │        │          │ 'RS38M-PROGRAMM'  │ 'YABAP_JHY_07_01'  │
* ├─────────────────┼────────┼──────────┼───────────────────┼────────────────────┤
* │                 │        │          │ 'BDC_OKCODE'      │ '=SHOP'            │
* └─────────────────┴────────┴──────────┴───────────────────┴────────────────────┘

  REFRESH gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-program  = 'SAPLWBABAP'.
  gs_bdcdata-dynpro   = '0100'.
  gs_bdcdata-dynbegin = abap_on.
  APPEND gs_bdcdata TO gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-fnam     = 'RS38M-PROGRAMM'.
  gs_bdcdata-fval     = pv_pname.
  APPEND gs_bdcdata TO gt_bdcdata.

  CLEAR gs_bdcdata.
  gs_bdcdata-fnam     = 'BDC_OKCODE'.
  gs_bdcdata-fval     = '=SHOP'.
  APPEND gs_bdcdata TO gt_bdcdata.

  DATA ls_options TYPE ctu_params.
  ls_options-dismode  = pa_mode.
  ls_options-updmode  = 'S'.
  ls_options-cattmode = abap_off.
  ls_options-nobinpt  = pa_nobin.
  ls_options-nobiend  = pa_nobie.
  ls_options-defsize  = pa_defsi.


  CALL TRANSACTION 'SE38' USING gt_bdcdata OPTIONS FROM ls_options.

ENDFORM.
