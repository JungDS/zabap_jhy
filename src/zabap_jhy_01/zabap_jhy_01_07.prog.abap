*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_07
*&---------------------------------------------------------------------*
*& Type Group 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_01_07.


* Type Group 사용하기
TYPE-POOLS YTYGR.
*--------------------------------------------------------------------*
* YTYGR 의 내용
*--------------------------------------------------------------------*
*TYPE-POOL YTYGR .
*TYPES YTYGR_S_SPFLI TYPE SPFLI.
*TYPES YTYGR_T_SPFLI TYPE TABLE OF SPFLI.
*--------------------------------------------------------------------*

* Type Group에 선언된 Type을 이용해서 변수를 선언
DATA GS_PFLI TYPE YTYGR_S_SPFLI.
DATA GT_PFLI TYPE YTYGR_T_SPFLI.


* Parameter 선언
PARAMETERS P_CHK AS CHECKBOX.

INITIALIZATION.

* 체크박스가 기본적으로 선택되도록 함
  P_CHK = ABAP_ON.


START-OF-SELECTION.


  IF P_CHK EQ ABAP_ON.
* 체크박스 선택 시 실행됨
    SELECT * FROM SPFLI INTO CORRESPONDING FIELDS OF TABLE GT_PFLI.

    TRY .
        DATA LO_ALV TYPE REF TO CL_SALV_TABLE.

        CALL METHOD CL_SALV_TABLE=>FACTORY
          IMPORTING
            R_SALV_TABLE = LO_ALV
          CHANGING
            T_TABLE      = GT_PFLI.

        CALL METHOD LO_ALV->DISPLAY.

      CATCH CX_SALV_MSG INTO DATA(LX_SALV_MSG).
        DATA(LV_MSG) = LX_SALV_MSG->GET_TEXT( ).
        MESSAGE LV_MSG TYPE 'I'.

    ENDTRY.

  ELSE.
* 체크박스 미선택 시 실행됨
    WRITE : / '@08@' AS ICON.
    WRITE : / '@09@' AS ICON.
    WRITE : / '@0A@' AS ICON.

    SKIP.

    WRITE : / ICON_GREEN_LIGHT.
    WRITE : / ICON_YELLOW_LIGHT.
    WRITE : / ICON_RED_LIGHT.
  ENDIF.

  IF P_CHK EQ 'X'.
* 체크박스 선택 시 실행됨
  ENDIF.

  CASE P_CHK.
    WHEN ABAP_ON.
* 체크박스 선택 시 실행됨
    WHEN ABAP_OFF.
* 체크박스 미선택 시 실행됨
  ENDCASE.

  CASE P_CHK.
    WHEN 'X'.
* 체크박스 선택 시 실행됨
    WHEN ''.
* 체크박스 미선택 시 실행됨
  ENDCASE.
