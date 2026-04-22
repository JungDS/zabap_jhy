*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_15
*&---------------------------------------------------------------------*
*& Selection Screen 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_15.

" 텍스트 심볼 사용을 위한 선언(실제 문자열은 INITIALIZATION에서 설정)
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_carrid TYPE scarr-carrid,
            p_cityfr TYPE spfli-cityfrom.
SELECT-OPTIONS: s_cityto FOR spfli-cityto.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-t01 = '조회 조건 입력'.

AT SELECTION-SCREEN.
  " 입력 검증: 항공사 코드는 필수
  IF p_carrid IS INITIAL.
    MESSAGE '항공사 코드(CARRID)는 필수입니다.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  WRITE: / '===== 입력값 확인 ====='.
  WRITE: / '항공사 코드   :', p_carrid.
  WRITE: / '출발 도시      :', p_cityfr.

  SKIP.
  WRITE: / '도착 도시 범위(SELECT-OPTIONS):'.
  LOOP AT s_cityto INTO DATA(ls_cityto).
    WRITE: / 'SIGN:', ls_cityto-sign,
             'OPTION:', ls_cityto-option,
             'LOW:', ls_cityto-low,
             'HIGH:', ls_cityto-high.
  ENDLOOP.
