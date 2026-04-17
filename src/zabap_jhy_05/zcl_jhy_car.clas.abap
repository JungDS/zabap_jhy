CLASS zcl_jhy_car DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_model
      RETURNING
        VALUE(rv_model) TYPE char20 .
    METHODS constructor
      IMPORTING
        iv_model TYPE char20
      RAISING
        zcx_jhy_car_model_check .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_model TYPE char20 .
ENDCLASS.



CLASS ZCL_JHY_CAR IMPLEMENTATION.


  METHOD constructor.

    IF iv_model IS INITIAL.

      RAISE EXCEPTION TYPE zcx_jhy_car_model_check
        EXPORTING
          REQUIRED_FIELD_LABEL = '자동차 모델명'(l01). " Class의 Text Symbols
    ENDIF.



    mv_model = iv_model.

  ENDMETHOD.


  METHOD get_model.

    rv_model = mv_model.

  ENDMETHOD.
ENDCLASS.
