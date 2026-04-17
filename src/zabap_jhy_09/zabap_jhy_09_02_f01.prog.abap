*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_data
*&---------------------------------------------------------------------*
FORM init_data .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_screen_1000
*&---------------------------------------------------------------------*
FORM modify_screen_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form user_command_1000
*&---------------------------------------------------------------------*
FORM user_command_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_data.

  SELECT FROM spfli
         FIELDS *
         WHERE carrid     IN @so_car
           AND connid     IN @so_con
           AND countryfr  IN @so_cntf
           AND cityfrom   IN @so_citf
           AND airpfrom   IN @so_airf
           AND countryto  IN @so_cntt
           AND cityto     IN @so_citt
           AND airpto     IN @so_airt
         ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @gt_data.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_display_data
*&---------------------------------------------------------------------*
FORM make_display_data .

  REFRESH gt_display.

  gt_display[] = CORRESPONDING #( gt_data ).

*  LOOP AT gt_display ASSIGNING FIELD-SYMBOL(<fs_display>).
*    <fs_display>-carrid = '변경'.
*  ENDLOOP.

  gv_lines = lines( gt_display ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
FORM display_data .

  CALL SCREEN 0100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

  go_container = NEW #( 'CCON_0100' ).
  go_alv_grid  = NEW #( go_container ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_layout_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100 .

  gs_layout = VALUE #(

    cwidth_opt  = abap_on
    zebra       = abap_on
    sel_mode    = 'D'

  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_fieldcat_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

  REFRESH gt_fieldcat.

  gt_fieldcat = VALUE #(
    ( fieldname = 'COUNTRYFR' coltext  = TEXT-f01 ) " Depart. Country
    ( fieldname = 'COUNTRYTO' coltext  = TEXT-f02 ) " Arrival Country
    ( fieldname = 'FLTYPE'    checkbox = abap_on  )
  ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv_grid_0100
*&---------------------------------------------------------------------*
FORM display_alv_grid_0100 .

  gs_variant = VALUE #(
    report = sy-repid
    handle = '0001'
  ).


  go_alv_grid->set_table_for_first_display(
    EXPORTING
      i_structure_name              = 'SPFLI'                 " Internal Output Table Structure Name
      is_variant                    = gs_variant              " Layout
      i_save                        = gv_save                 " Save Layout
      is_layout                     = gs_layout               " Layout
    CHANGING
      it_outtab                     = gt_display              " Output Table
      it_fieldcatalog               = gt_fieldcat             " Field Catalog
      it_sort                       = gt_sort
    EXCEPTIONS
      OTHERS                        = 1
  ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid_0100
*&---------------------------------------------------------------------*
FORM refresh_grid_0100.

  CHECK go_alv_grid IS BOUND.

  go_alv_grid->refresh_table_display(
    EXPORTING
      is_stable      = VALUE #( row = abap_on
                                col = abap_on ) " With Stable Rows/Columns
      i_soft_refresh = abap_on                  " Without Sort, Filter, etc.
  ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_sort_0100
*&---------------------------------------------------------------------*
FORM set_alv_sort_0100 .

  REFRESH gt_sort.

  gt_sort = VALUE #(
    ( spos = 1 fieldname = 'CARRID' up = abap_on  )
    ( spos = 2 fieldname = 'CONNID' up = abap_on  )
  ).

ENDFORM.
