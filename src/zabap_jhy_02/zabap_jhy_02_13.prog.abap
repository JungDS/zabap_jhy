*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_13
*&---------------------------------------------------------------------*
*& SPLIT 예제
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_13.


* 검색된 데이터를 구분자(',') 기준의 하나의 문자열로 연결한 문자열 변수와 Internal Table
DATA gv_line TYPE string.
DATA gt_line TYPE TABLE OF string.


START-OF-SELECTION.

* 필드 3개만 조회해서 Internal Table에 보관한다.
  SELECT FROM scarr
         FIELDS carrid, carrname, currcode
         INTO TABLE @DATA(lt_carr)
         UP TO 5 ROWS.

* 검색된 데이터의 각 라인마다 ','를 기준으로 한 줄의 문자열로 만들어 GT_LINE 에 쌓는다.
  PERFORM make_line_from_data USING lt_carr.


  DATA: lv_v1 TYPE string,
        lv_v2 TYPE string,
        lv_v3 TYPE string.


  ULINE.
  WRITE :/(9999) 'SPLIT 문법에서               을 사용한 예제' COLOR COL_HEADING.
  WRITE : AT 16(10) 'INTO TABLE' COLOR COL_GROUP.
*  ULINE.
  WRITE : /(50) sy-uline.
  WRITE : /'|',(10) '항공사ID','|',(20) '항공사명','|',(10) '통화코드','|'.
  WRITE : /(50) sy-uline.

  LOOP AT gt_line INTO gv_line.

    SPLIT gv_line AT ',' INTO TABLE DATA(lt_value).

    lv_v1 = lt_value[ 1 ].
    lv_v2 = lt_value[ 2 ].
    lv_v3 = lt_value[ 3 ].

    WRITE :/'|', (10) lv_v1, '|',(20) LV_V2, '|', (10) LV_V3, '|'.

  ENDLOOP.
  WRITE : /(50) sy-uline.

  SKIP 2.

  ULINE.
  WRITE :/(9999) 'SPLIT 문법에서         를 사용한 예제' COLOR COL_HEADING.
  WRITE : AT 16(4) 'INTO' COLOR COL_GROUP.
  WRITE :/ '→ 의도하지 않게 마지막 필드에 구분자가 남아있다.'.
*  ULINE.
  WRITE : /(50) sy-uline.
  WRITE : /'|',(10) '항공사ID','|',(20) '항공사명','|',(10) '통화코드','|'.
  WRITE : /(50) sy-uline.

  LOOP AT gt_line INTO gv_line.

*   ','를 (전달받는 변수의 수 - 1) 만큼만 제거한다.
*   아래 예제는 ','를 2개만 제거한다.
    SPLIT gv_line AT ',' INTO lv_v1
                              lv_v2
                              lv_v3.

    WRITE :/'|', (10) lv_v1, '|',(20) LV_V2, '|', (10) LV_V3, '|'.

  ENDLOOP.
  WRITE : /(50) sy-uline.




*&---------------------------------------------------------------------*
*& Form MAKE_LINE_FROM_DATA
*&---------------------------------------------------------------------*
*& 전달받은 Internl Table의 각 라인을 하나의 문자열로 만드는 Subroutine
*&---------------------------------------------------------------------*
FORM make_line_from_data USING pt_data TYPE ANY TABLE.

  DATA lv_count TYPE i.


  WRITE :/(9999) '검색한 데이터의 필드들을 한 줄로 만들고 '',''로 구분자를 둔 경우' COLOR COL_HEADING.
  ULINE.


  LOOP AT pt_data ASSIGNING FIELD-SYMBOL(<fs_wa>).

    CLEAR gv_line.
    CLEAR lv_count.

    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO FIELD-SYMBOL(<fs>).
      IF sy-subrc EQ 0.
        lv_count += 1.
        IF sy-index EQ 1.
          gv_line = |{ <fs> },|.
        ELSE.
          gv_line = |{ gv_line }{ <fs> },|.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    WRITE / gv_line.
    APPEND gv_line TO gt_line.

  ENDLOOP.

  SKIP 2.

*  WRITE / lv_count.


ENDFORM.
