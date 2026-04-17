*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_10
*&---------------------------------------------------------------------*
*& 입력값 점검 ( Radio Button )
*&---------------------------------------------------------------------*
REPORT zabap_jhy_03_10.


* TEXT-T01 : Selection Options
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.

  PARAMETERS: pa_ag RADIOBUTTON GROUP rag1, " 동의
              pa_rj RADIOBUTTON GROUP rag1. " 거절

  PARAMETERS: pa_car TYPE scarr-carrid,
              pa_con TYPE spfli-connid.

SELECTION-SCREEN END OF BLOCK b01.

INITIALIZATION.
  pa_rj = abap_on.

* 거절을 선택한 경우 오류 메시지 출력
AT SELECTION-SCREEN ON RADIOBUTTON GROUP rag1.
  CASE abap_on.
    WHEN pa_ag.
*     오류메시지 없음
    WHEN pa_rj.
*     오류메시지 출력
      MESSAGE TEXT-e01 TYPE 'E'. " 동의하셔야 진행이 가능합니다.
  ENDCASE.

START-OF-SELECTION.

* Selection Screen에서
  MESSAGE TEXT-m01 TYPE 'I'. " 다음 단계 진행 성공
