*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_00
*&---------------------------------------------------------------------*
*& Inline 선언 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_00.

START-OF-SELECTION.

* 주어진 값의 타입과 길이에 따라 자동으로 변수를 선언한다.
  DATA(lv_a) = 'Hello World!'.  " 문자
  DATA(lv_b) = '안녕하세요'.    " 문자
  DATA(lv_c) = 123.             " 숫자
  DATA(lv_d) = '00123'.         " 문자


  WRITE :/ 'lv_A =', lv_a.
  WRITE :/ 'lv_B =', (10) lv_b. " 한글 출력 시 2자리씩 차지해서 문자수(5문자)만큼 출력하면 잘린다.
*                             " 그래서 5문자면 2배인 10자리로 직접 길이를 지정해야 잘리지 않는다.
  WRITE :/ 'lv_C =', lv_c.
  WRITE :/ 'lv_D =', lv_d.

  SKIP 2.



* 직접 Internal Table을 선언하고 데이터를 조회하는 방식
  TYPES: BEGIN OF ty_s_data,
           carrid   TYPE spfli-carrid,
           connid   TYPE spfli-connid,
           cityfrom TYPE spfli-cityfrom,
           cityto   TYPE spfli-cityto,
         END OF ty_s_data.

  DATA lt_data TYPE TABLE OF ty_s_data.

  SELECT carrid connid cityfrom cityto
    FROM spfli
    INTO TABLE lt_data.

* 데이터를 조회하면서 동시에 선언하는 방식 => select 에 적힌 테이블과 필드정보를 통해서 itab 구조가 결정됨
  SELECT carrid, connid, cityfrom, cityto
    FROM spfli
    INTO TABLE @DATA(lt_data_inline).


  IF lt_data EQ lt_data_inline.
    WRITE / '직접 선언한 Itab과 Inline으로 선언한 Itab이 동일하다.'.
  ELSE.
    WRITE / '직접 선언한 Itab과 Inline으로 선언한 Itab이 불일치하다.'.
  ENDIF.
