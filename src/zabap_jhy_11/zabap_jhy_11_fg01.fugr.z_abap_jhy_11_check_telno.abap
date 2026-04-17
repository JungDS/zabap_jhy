FUNCTION z_abap_jhy_11_check_telno.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_NUMBER) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(EV_SUCCESS) TYPE  C
*"----------------------------------------------------------------------

  DATA: lv_pattern TYPE string,
        lo_regex   TYPE REF TO cl_abap_regex,
        lo_matcher TYPE REF TO cl_abap_matcher.

* 전화번호를 점검하기 위한 정규식
* 지역번호 or 휴대폰 번호를 입력할 수 있도록 점검함
  lv_pattern = '^(0(2|[3-6][0-9])-\d{3,4}-\d{4})|(01[016789]-\d{3,4}-\d{4})$'.

  TRY.
      lo_regex   = cl_abap_regex=>create_pcre( lv_pattern ).
      lo_matcher = lo_regex->create_matcher( text = IV_NUMBER ).
      ev_success = lo_matcher->match( ).

*      ev_success = match( val = IV_NUMBER pcre = lv_pattern ).

    CATCH cx_sy_regex.   " System Exceptions for Regular Expressions
    CATCH cx_sy_matcher. " System Exceptions for Regular Expressions.
  ENDTRY.


ENDFUNCTION.
