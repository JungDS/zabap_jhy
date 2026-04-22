*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_16
*&---------------------------------------------------------------------*
*& Open SQL 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_16.

TYPES: BEGIN OF ty_spfli,
         carrid   TYPE spfli-carrid,
         connid   TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
       END OF ty_spfli.

DATA gt_spfli TYPE STANDARD TABLE OF ty_spfli WITH EMPTY KEY.
DATA gs_spfli TYPE ty_spfli.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_carrid TYPE spfli-carrid.
SELECT-OPTIONS: s_connid FOR gs_spfli-connid.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-t01 = 'SPFLI 조회 조건'.

START-OF-SELECTION.
  " Selection Screen 조건 기반 조회
  SELECT carrid, connid, cityfrom, cityto
    FROM spfli
    INTO TABLE @gt_spfli
    WHERE carrid = @p_carrid
      AND connid IN @s_connid.

  " sy-subrc 체크: SELECT 성공 여부 확인
  IF sy-subrc <> 0 OR gt_spfli IS INITIAL.
    WRITE: / '조회 결과가 없습니다.'.
    RETURN.
  ENDIF.

  WRITE: / '===== SPFLI 조회 결과 ====='.
  LOOP AT gt_spfli INTO gs_spfli.
    WRITE: / '항공사:', gs_spfli-carrid,
             '편명:', gs_spfli-connid,
             '출발:', gs_spfli-cityfrom,
             '도착:', gs_spfli-cityto.
  ENDLOOP.
