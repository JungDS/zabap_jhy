FUNCTION z_abap_jhy_11_check_pstcd.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_POSTAL_CODE) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(EV_SUCCESS) TYPE  C
*"----------------------------------------------------------------------

  DATA: lv_pattern TYPE string,
        lo_regex   TYPE REF TO cl_abap_regex,
        lo_matcher TYPE REF TO cl_abap_matcher.

  lv_pattern = '^\d{5}$'.               " 숫자 5자만 허용: 현재 한국은 우편번호 5자리만 허용

* lv_pattern = '^\d{3}-\d{3}$'.         " 하이픈(-)으로 구분한 숫자 3자 두 번만 허용 : 옛 우편번호 방식

* lv_pattern = '^\d{5}$|^\d{3}-\d{3}$'. " 숫자 5자 또는 하이픈(-)으로 구분한 숫자 3자 두 번 : 둘 다 허용

  TRY.
      lo_regex   = cl_abap_regex=>create_pcre( lv_pattern ).
      lo_matcher = lo_regex->create_matcher( text = iv_postal_code ).
      ev_success = lo_matcher->match( ).

      ev_success = MATCH( val = iv_postal_code pcre = lv_pattern ).

    CATCH cx_sy_regex.   " System Exceptions for Regular Expressions
    CATCH cx_sy_matcher. " System Exceptions for Regular Expressions.
  ENDTRY.


ENDFUNCTION.
