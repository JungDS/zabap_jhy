*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_00_CLS
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Class (Definition) lcl_event_handler
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_click              FOR EVENT click OF cl_gui_chart_engine
        IMPORTING
          element
          series
          point,

      on_value_change       FOR EVENT value_change OF cl_gui_chart_engine
        IMPORTING
          series
          point
          value,

      on_property_change    FOR EVENT property_change OF cl_gui_chart_engine
        IMPORTING
          element
          name
          value.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_click.

    DATA: l_msg    TYPE c LENGTH 300,
          l_series TYPE string,
          l_point  TYPE string.

    l_series = series.
    l_point = point.

    CLEAR gs_carr.
    READ TABLE gt_carr INTO gs_carr INDEX series.

    IF sy-subrc EQ 0.

      l_msg+000(50) = |Element clicked: { element }|.
      l_msg+048(02) = '　'.
      l_msg+050(50) = |Series: { l_series }({ gs_carr-carrname })|.
      l_msg+098(02) = '　'.
      l_msg+100(50) = |Point: { l_point }|.
    ELSE.
      l_msg+000(50) = |Element clicked: { element }|.

    ENDIF.

    MESSAGE l_msg TYPE 'I'.

  ENDMETHOD.

  METHOD on_value_change.

    DATA: l_msg    TYPE string,
          l_series TYPE string,
          l_point  TYPE string,
          l_value  TYPE string.

    l_series = series.
    l_point = point.
    l_value = value.
    CONCATENATE 'Value changed:'
                'Series:' l_series
                'Point:' l_point
                'Value:' l_value
           INTO l_msg SEPARATED BY space.
    MESSAGE l_msg TYPE 'I'.

  ENDMETHOD.

  METHOD on_property_change.

    DATA: l_msg    TYPE string.

    CONCATENATE 'Property changed:'
                'Element:' element
                'Name:' name
                'Value:' value
           INTO l_msg SEPARATED BY space.
    MESSAGE l_msg TYPE 'I'.

  ENDMETHOD.

ENDCLASS.
