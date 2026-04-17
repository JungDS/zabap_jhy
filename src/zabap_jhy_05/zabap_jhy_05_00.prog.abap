*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_05_00
*&---------------------------------------------------------------------*
*& Subroutine 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_05_00.


WRITE / 'Subroutine 첫번째 호출 전' COLOR COL_HEADING.
PERFORM write_list.
WRITE / 'Subroutine 첫번째 호출 후' COLOR COL_HEADING.

SKIP.   " 한줄 건너띄기
ULINE.  " 밑줄 긋기
SKIP.   " 한줄 건너띄기

WRITE / 'Subroutine 두번째 호출 전' COLOR COL_HEADING.
PERFORM write_list.
WRITE / 'Subroutine 두번째 호출 후' COLOR COL_HEADING.

*--------------------------------------------------------------------*
* Subroutine 생성
* FORM 키워드 + Subroutine의 이름
*--------------------------------------------------------------------*
FORM write_list.

  SKIP. " 한줄 건너띄기
  ULINE. " 밑줄 긋기
  WRITE / 'LH Lufthansa'.
  WRITE / 'AA American Airlines'.
  WRITE / 'UA United Airlines'.
  ULINE. " 밑줄 긋기
  SKIP. " 한줄 건너띄기

ENDFORM.
