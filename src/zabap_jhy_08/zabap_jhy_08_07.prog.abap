*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_08_07
*&---------------------------------------------------------------------*
*& Field Symbol 항공사별 연간 매출액 출력하기
*&---------------------------------------------------------------------*
REPORT zabap_jhy_08_07.


TABLES sflight.

DATA: BEGIN OF gs_data,

        carrid     TYPE sflight-carrid,
        connid     TYPE sflight-connid,
        month      TYPE c LENGTH 6,
        paymentsum TYPE sflight-paymentsum,
        currency   TYPE sflight-currency,

      END OF gs_data.

DATA: BEGIN OF gs_display,

        carrid   TYPE sflight-carrid,
        connid   TYPE sflight-connid,
        year     TYPE n LENGTH 4,
        mon01    TYPE sflight-paymentsum,
        mon02    TYPE sflight-paymentsum,
        mon03    TYPE sflight-paymentsum,
        mon04    TYPE sflight-paymentsum,
        mon05    TYPE sflight-paymentsum,
        mon06    TYPE sflight-paymentsum,
        mon07    TYPE sflight-paymentsum,
        mon08    TYPE sflight-paymentsum,
        mon09    TYPE sflight-paymentsum,
        mon10    TYPE sflight-paymentsum,
        mon11    TYPE sflight-paymentsum,
        mon12    TYPE sflight-paymentsum,
        currency TYPE sflight-currency,

      END OF gs_display.


DATA: gt_data    LIKE TABLE OF gs_data,
      gt_display LIKE TABLE OF gs_display.

DATA: go_salv    TYPE REF TO cl_salv_table.

FIELD-SYMBOLS <fs_mon> TYPE sflight-paymentsum.



* TEXT-S01 : Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

  SELECT-OPTIONS: so_car FOR sflight-carrid,
                  so_con FOR sflight-connid,
                  so_year FOR gs_display-year.

SELECTION-SCREEN END OF BLOCK b01.


START-OF-SELECTION.




  SELECT FROM sflight
         FIELDS carrid, connid, left( fldate, 6 ) AS month, SUM( paymentsum ), currency
         WHERE carrid IN @so_car
           AND connid IN @so_con
         GROUP BY carrid, connid, left( fldate, 6 ), currency
         ORDER BY carrid, connid, month
          INTO TABLE @gt_data.




  DATA lv_fieldname TYPE fieldname.

  LOOP AT gt_data INTO gs_data.

    CLEAR gs_display.
    gs_display-carrid = gs_data-carrid.
    gs_display-connid = gs_data-connid.
    gs_display-currency = gs_data-currency.

    gs_display-year = gs_data-month(4).

    lv_fieldname = |MON{ gs_data-month+4(2) }|.
    ASSIGN COMPONENT lv_fieldname OF STRUCTURE gs_display TO <fs_mon>.
    IF sy-subrc EQ 0.
      <fs_mon> = gs_data-paymentsum.
      UNASSIGN <fs_mon>.
    ENDIF.

    COLLECT gs_display INTO gt_display.

  ENDLOOP.





  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table   = go_salv                          " Basis Class Simple ALV Tables
        CHANGING
          t_table        = gt_display
      ).

      DATA(lo_sort)  = go_salv->get_sorts( ).

      DATA(lo_aggre) = go_salv->get_aggregations( ).

      DATA(lo_columns) = go_salv->get_columns( ).
      lo_columns->set_optimize( ).



      DATA lo_column  TYPE REF TO cl_salv_column_table.
      DATA lv_coltext TYPE string.

      LOOP AT lo_columns->get( ) INTO DATA(ls_column).
        lo_column ?= ls_column-r_column.

        CASE ls_column-columnname.
          WHEN 'CARRID'.
            lo_column->set_key( ).
            TRY.
                lo_sort->add_sort( position   = 1
                                   columnname = ls_column-columnname
                                   subtotal   = abap_on ).
              CATCH cx_salv_data_error.
              CATCH cx_salv_not_found.
              CATCH cx_salv_existing.
            ENDTRY.
          WHEN 'CONNID'.
*            lo_columns->set_column_position( columnname = ls_column-columnname
*                                             position   = 2 ).
            lo_column->set_key( ).

          WHEN 'YEAR'.
            lv_coltext = 'Year'(f01).
            lo_columns->set_column_position( columnname = ls_column-columnname
                                             position   = 2 ).
            TRY.
                lo_sort->add_sort( position   = 2
                                   columnname = ls_column-columnname
                                   subtotal   = abap_on ).
              CATCH cx_salv_data_error.
              CATCH cx_salv_not_found.
              CATCH cx_salv_existing.
            ENDTRY.

            lo_column->set_short_text(  CONV #( lv_coltext ) ).
            lo_column->set_medium_text( CONV #( lv_coltext ) ).
            lo_column->set_long_text(   CONV #( lv_coltext ) ).
          WHEN OTHERS.

            IF ls_column-columnname(3) EQ 'MON'.
              TRY.
                  lo_aggre->add_aggregation( ls_column-columnname ).

                CATCH cx_salv_data_error.
                CATCH cx_salv_not_found.
                CATCH cx_salv_existing.
              ENDTRY.

              lv_coltext = |Mon { ls_column-columnname+3(2) ALPHA = OUT } Sales|.

              lo_column->set_short_text(  CONV #( lv_coltext ) ).
              lo_column->set_medium_text( CONV #( lv_coltext ) ).
              lo_column->set_long_text(   CONV #( lv_coltext ) ).


              TRY.
                  lo_column->set_currency_column( 'CURRENCY' ).
                CATCH cx_salv_not_found.  " ALV: General Error Class (Checked in Syntax Check)
                CATCH cx_salv_data_error. " ALV: General Error Class (Checked in Syntax Check)
              ENDTRY.
            ENDIF.
        ENDCASE.

      ENDLOOP.

      go_salv->display( ).


    CATCH cx_salv_msg. " ALV: General Error Class with Message

  ENDTRY.
