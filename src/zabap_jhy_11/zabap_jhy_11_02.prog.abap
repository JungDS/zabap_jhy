*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_11_02
*&---------------------------------------------------------------------*
*& 정규식의 성능 비교
*& Benchmark: CS / CA / CP / NP / PCRE(REGEX)
*&---------------------------------------------------------------------*
REPORT zabap_jhy_11_02.


CONSTANTS: c_max_rows TYPE i VALUE 100000.

"--- 테스트 패턴 (의미적으로 동일하도록 구성)
CONSTANTS:
  c_substr  TYPE string VALUE 'LH',          " 포함 여부 (CS)
  c_charset TYPE string VALUE '0123456789',  " 숫자 포함 여부 (CA)
  c_cp_pat  TYPE string VALUE '*LH*',        " 포함 여부를 CP로 흉내
  c_np_pat  TYPE string VALUE '*LH*',        " 거의 매칭 안되도록
  c_regex   TYPE string VALUE '^LH.*$'.          " 포함 여부를 REGEX로 흉내(단순)

PARAMETERS:
  p_rows TYPE i DEFAULT 100000.

DATA: lt_sbook TYPE STANDARD TABLE OF sbook,
      lv_rows  TYPE i.

" 타임스탬프(UTC long) - 8 bytes
DATA: lv_ts_start TYPE timestampl,
      lv_ts_end   TYPE timestampl.

" 누적 시간(마이크로초 단위) -> ms로 출력
DATA: lv_us_cs    TYPE i,
      lv_us_ca    TYPE i,
      lv_us_cp    TYPE i,
      lv_us_np    TYPE i,
      lv_us_rgx1  TYPE i,   " FIND REGEX 직접
      lv_us_rgx2  TYPE i,   " CL_ABAP_REGEX 사전컴파일
      lv_us_match TYPE i.

" 결과 카운트(최적화 방지/동일성 확인)
DATA: lv_cnt_cs    TYPE i,
      lv_cnt_ca    TYPE i,
      lv_cnt_cp    TYPE i,
      lv_cnt_np    TYPE i,
      lv_cnt_rgx1  TYPE i,
      lv_cnt_rgx2  TYPE i,
      lv_cnt_match TYPE i.

" REGEX 객체(사전 컴파일용)
DATA: lo_regex   TYPE REF TO cl_abap_regex,
      lo_matcher TYPE REF TO cl_abap_matcher.

START-OF-SELECTION.

  lv_rows = p_rows.
  IF lv_rows IS INITIAL OR lv_rows < 1.
    lv_rows = c_max_rows.
  ENDIF.
  IF lv_rows > c_max_rows.
    lv_rows = c_max_rows.
  ENDIF.

  "---------------------------------------------------------------
  " 1) 데이터 로드 (최대 lv_rows)
  "---------------------------------------------------------------
  SELECT * FROM sbook
    UP TO @lv_rows ROWS
    INTO TABLE @lt_sbook.

  lv_rows = sy-dbcnt.

  WRITE: / 'Benchmark target table: SBOOK',
         / 'Loaded rows:', lv_rows,
         /.

  IF lv_rows = 0.
    WRITE: / 'No data found in SBOOK. Stop.'.
    RETURN.
  ENDIF.

  "---------------------------------------------------------------
  " 도움 메소드: 두 timestampl 차이를 마이크로초로 변환
  " (ABAP 표준 FM: TIMESTAMP_DURATION 사용)
  "---------------------------------------------------------------
  " 실제 측정은 아래 FORM에서 수행

  "---------------------------------------------------------------
  " 2) CS benchmark
  "---------------------------------------------------------------
  PERFORM bench_cs USING lt_sbook CHANGING lv_us_cs lv_cnt_cs.

  "---------------------------------------------------------------
  " 3) CA benchmark
  "---------------------------------------------------------------
  PERFORM bench_ca USING lt_sbook CHANGING lv_us_ca lv_cnt_ca.

  "---------------------------------------------------------------
  " 4) CP benchmark
  "---------------------------------------------------------------
  PERFORM bench_cp USING lt_sbook CHANGING lv_us_cp lv_cnt_cp.

  "---------------------------------------------------------------
  " 5) NP benchmark
  "---------------------------------------------------------------
  PERFORM bench_np USING lt_sbook CHANGING lv_us_np lv_cnt_np.

  "---------------------------------------------------------------
  " 6) PCRE #1 : FIND REGEX (매번 패턴 처리)
  "---------------------------------------------------------------
  PERFORM bench_regex_find USING lt_sbook CHANGING lv_us_rgx1 lv_cnt_rgx1.

  "---------------------------------------------------------------
  " 7) PCRE #2 : CL_ABAP_REGEX 사전 컴파일 + matcher 재사용
  "---------------------------------------------------------------
  PERFORM bench_regex_obj USING lt_sbook CHANGING lv_us_rgx2 lv_cnt_rgx2.

  "---------------------------------------------------------------
  " 8) match
  "---------------------------------------------------------------
  PERFORM bench_match USING lt_sbook CHANGING lv_us_match lv_cnt_match.


  "---------------------------------------------------------------
  " 9) 결과 출력
  "---------------------------------------------------------------
  PERFORM print_result USING lv_rows
                            lv_us_cs   lv_cnt_cs
                            lv_us_ca   lv_cnt_ca
                            lv_us_cp   lv_cnt_cp
                            lv_us_np   lv_cnt_np
                            lv_us_rgx1 lv_cnt_rgx1
                            lv_us_rgx2 lv_cnt_rgx2
                            lv_us_match lv_cnt_match.


*-----------------------------------------------------------------------
* Benchmarks Subroutine
*-----------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Form bench_cs
*&---------------------------------------------------------------------*
FORM bench_cs USING    it_sbook TYPE STANDARD TABLE
              CHANGING cv_us    TYPE i
                       cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lv_text = <s>-carrid.  " 문자열 길이 짧고, 대부분 NULL 아님
    IF lv_text CS c_substr.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form bench_ca
*&---------------------------------------------------------------------*
FORM bench_ca USING    it_sbook TYPE STANDARD TABLE
              CHANGING cv_us    TYPE i
                       cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lv_text = <s>-customid.
    IF lv_text CA c_charset.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form bench_cp
*&---------------------------------------------------------------------*
FORM bench_cp USING    it_sbook TYPE STANDARD TABLE
              CHANGING cv_us    TYPE i
                       cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lv_text = <s>-carrid.
    IF lv_text CP c_cp_pat.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form bench_np
*&---------------------------------------------------------------------*
FORM bench_np USING    it_sbook TYPE STANDARD TABLE
              CHANGING cv_us    TYPE i
                       cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lv_text = <s>-carrid.
    IF lv_text NP c_np_pat.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form bench_regex_find
*&---------------------------------------------------------------------*
FORM bench_regex_find USING    it_sbook TYPE STANDARD TABLE
                      CHANGING cv_us    TYPE i
                               cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lv_text = <s>-carrid.
    FIND REGEX c_substr IN lv_text.
    IF sy-subrc = 0.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form bench_regex_obj
*&---------------------------------------------------------------------*
FORM bench_regex_obj USING    it_sbook TYPE STANDARD TABLE
                     CHANGING cv_us    TYPE i
                              cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  lo_regex   = cl_abap_regex=>create_pcre( c_substr ).

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    lo_matcher = lo_regex->create_matcher( text = <s>-carrid ).
    IF lo_matcher->match( ).
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form bench_match
*&---------------------------------------------------------------------*
FORM bench_match    USING    it_sbook TYPE STANDARD TABLE
                    CHANGING cv_us    TYPE i
                             cv_cnt   TYPE i.

  DATA: lv_text TYPE string.
  DATA: lv_ts1  TYPE timestampl,
        lv_ts2  TYPE timestampl,
        lv_diff TYPE i.

  FIELD-SYMBOLS <s> TYPE sbook.

  cv_cnt = 0.

  GET TIME STAMP FIELD lv_ts1.

  LOOP AT it_sbook ASSIGNING <s>.
    IF match( val = <s>-carrid pcre = c_substr ) NE SPACE.
      cv_cnt += 1.
    ENDIF.
  ENDLOOP.

  GET TIME STAMP FIELD lv_ts2.

  PERFORM ts_diff_us USING lv_ts1 lv_ts2 CHANGING lv_diff.
  cv_us = lv_diff.

ENDFORM.

*-----------------------------------------------------------------------
* Timestamp diff -> microseconds
*-----------------------------------------------------------------------
FORM ts_diff_us USING    iv_ts1 TYPE timestampl
                         iv_ts2 TYPE timestampl
                CHANGING cv_us  TYPE i.

  " Standard FM (available in NetWeaver ABAP): TIMESTAMP_DURATION
  " Result is in seconds + microseconds
  cv_us = iv_ts1 * 1000000 - iv_ts2 * 1000000.

ENDFORM.

*-----------------------------------------------------------------------
* Result print
*-----------------------------------------------------------------------
FORM print_result USING iv_rows     TYPE i
                        iv_us_cs    TYPE i    iv_cnt_cs     TYPE i
                        iv_us_ca    TYPE i    iv_cnt_ca     TYPE i
                        iv_us_cp    TYPE i    iv_cnt_cp     TYPE i
                        iv_us_np    TYPE i    iv_cnt_np     TYPE i
                        iv_us_rgx1  TYPE i    iv_cnt_rgx1   TYPE i
                        iv_us_rgx2  TYPE i    iv_cnt_rgx2   TYPE i
                        iv_us_match TYPE i    iv_cnt_match  TYPE i.

  DATA: lv_ms_cs    TYPE p DECIMALS 3,
        lv_ms_ca    TYPE p DECIMALS 3,
        lv_ms_cp    TYPE p DECIMALS 3,
        lv_ms_np    TYPE p DECIMALS 3,
        lv_ms_rgx1  TYPE p DECIMALS 3,
        lv_ms_rgx2  TYPE p DECIMALS 3,
        lv_ms_match TYPE p DECIMALS 3.

  lv_ms_cs    = iv_us_cs    / 1000.
  lv_ms_ca    = iv_us_ca    / 1000.
  lv_ms_cp    = iv_us_cp    / 1000.
  lv_ms_np    = iv_us_np    / 1000.
  lv_ms_rgx1  = iv_us_rgx1  / 1000.
  lv_ms_rgx2  = iv_us_rgx2  / 1000.
  lv_ms_match = iv_us_match / 1000.

  WRITE: / '------------------------------------------------------------'.
  WRITE: / 'Rows:', iv_rows.
  WRITE: / 'Pattern 의미:',
         / '  CS : contains "LH"',
         / '  CA : contains any digit',
         / '  CP : "*LH*"',
         / '  NP : NOT "*ZZZZ*" (거의 항상 TRUE)',
         / '  REGEX : "LH" (contains와 유사)',
         /.

  WRITE: / '------------------------------------------------------------'.
  WRITE: /(12) 'Method', 14 'Time(ms)', 30 'Matches'.
  WRITE: / '------------------------------------------------------------'.

  WRITE: /(12) 'CS',    14 lv_ms_cs,    30 iv_cnt_cs.
  WRITE: /(12) 'CA',    14 lv_ms_ca,    30 iv_cnt_ca.
  WRITE: /(12) 'CP',    14 lv_ms_cp,    30 iv_cnt_cp.
  WRITE: /(12) 'NP',    14 lv_ms_np,    30 iv_cnt_np.
  WRITE: /(12) 'REGEX1',14 lv_ms_rgx1,  30 iv_cnt_rgx1.
  WRITE: /(12) 'REGEX2',14 lv_ms_rgx2,  30 iv_cnt_rgx2.
  WRITE: /(12) 'match', 14 lv_ms_match, 30 iv_cnt_match.

  WRITE: / '------------------------------------------------------------'.
  WRITE: / 'Note: REGEX2는 CL_ABAP_REGEX 사전 컴파일로 REGEX1 대비 개선되는지 확인용.'.

ENDFORM.
