*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_05
*&---------------------------------------------------------------------*
*& 구구단 출력 프로그램 v2
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_05.

DATA: gv_dan TYPE i,
      gv_num TYPE i.

START-OF-SELECTION.
  DO 8 TIMES.
    gv_dan = sy-index + 1.

    WRITE: / |[{ gv_dan } 단]|.

    DO 9 TIMES.
      gv_num = sy-index.
      WRITE: / |{ gv_dan } x { gv_num } = { gv_dan * gv_num }|.
    ENDDO.

    ULINE.
  ENDDO.
