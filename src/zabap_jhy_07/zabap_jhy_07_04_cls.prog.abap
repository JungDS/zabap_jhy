*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_04_CLS
*&---------------------------------------------------------------------*

* 클래스 LCL_EVENT_HANDLER 에 대한 정의 ( 메소드 와 어트리뷰트 )
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    " Static Method
    CLASS-METHODS on_button_click FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING es_row_no   " 이벤트가 발생한 행
                es_col_id   " 이벤트가 발생한 열
                sender.     " 이벤트가 발생한 ALV 객체
  PRIVATE SECTION.
ENDCLASS.

* 클래스 LCL_EVENT_HANDLER 의 메소드에 대한 구현
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_button_click. " 위 정의에 대한 구현

    CASE es_col_id-fieldname.
      WHEN 'CANCEL_BTTXT'.  " 일정 취소 버튼인지

        PERFORM handle_button_click_cancel USING es_row_no.



      WHEN OTHERS.          " 아니면 다른 버튼인지
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
