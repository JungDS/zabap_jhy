*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_01_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_scarr.

  SELECT * FROM scarr
           INTO TABLE gt_scarr
           WHERE carrid IN so_car
           ORDER BY PRIMARY KEY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  CREATE OBJECT go_container
    EXPORTING
      container_name = 'CCON' " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

* ALV 의 화면에 데이터를 출력하기 위한 Method
* ALV Grid로 화면에 출력할 때 가장 간단한 형태
  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR' " Internal Output Table Structure Name
    CHANGING
      it_outtab        = gt_scarr " Output Table
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
