*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_17
*&---------------------------------------------------------------------*
*& FORM 모듈화 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_17.

" 모듈화 목적:
" - 큰 프로그램을 의미 단위로 분리해 읽기 쉽게 만든다.
" - 재사용/유지보수를 쉽게 한다.

TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_scarr.

DATA gt_scarr TYPE STANDARD TABLE OF ty_scarr WITH EMPTY KEY.
DATA gs_scarr TYPE ty_scarr.

START-OF-SELECTION.
  PERFORM init_data.
  PERFORM get_data.
  PERFORM display_data.

FORM init_data.
  " 초기화 로직 (예: 기존 데이터 비우기)
  CLEAR gt_scarr.
ENDFORM.

FORM get_data.
  " 데이터 조회 로직
  SELECT carrid, carrname, currcode
    FROM scarr
    INTO TABLE @gt_scarr
    UP TO 10 ROWS.
ENDFORM.

FORM display_data.
  " 출력 로직
  IF gt_scarr IS INITIAL.
    WRITE: / '조회된 항공사 데이터가 없습니다.'.
    RETURN.
  ENDIF.

  WRITE: / '===== SCARR 상위 10건 ====='.
  LOOP AT gt_scarr INTO gs_scarr.
    WRITE: / gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.
  ENDLOOP.
ENDFORM.
