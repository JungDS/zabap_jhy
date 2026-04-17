*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_CLS
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Class (Definition) LCL_EVENT_HANDLER
*& 프로그램에서 각종 다양한 클래스의 객체들이 발생시키는 이벤트 중
*& 특정 이벤트에 대해 자동으로 실행되는 메소드를 정의한 Local Class다.
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.

*   이 메소드는 [ 클래스 CL_GUI_ALV_GRID ] 의 [ 이벤트 DOUBLE_CLICK ] 를 위한 메소드다.
*   이 메소드가 이벤트에 의해 실행될 때 취급할 Parameter 정보를 미리 정의할 수 있다.
    METHODS:
      on_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row     " DOUBLE CLICK이 발생한 행
                  e_column  " DOUBLE CLICK이 발생한 열
                  sender.   " 이벤트를 발생시킨 ALV 참조변수

ENDCLASS.

*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

*--------------------------------------------------------------------*
* Method ON_DOUBLE_CLICK 시작
*--------------------------------------------------------------------*
  METHOD on_double_click.

    DATA lv_carrid TYPE scarr-carrid.

*   화면에 출력된 ALV의 데이터는 [ GT_DISPLAY ]를 기반으로 출력한다.
*   그러므로 사용자가 특정 행을 Double Click 했으면,
*   그 정보를 통해 [ GT_DISPLAY ]에서 특정 행을 찾을 때, 그 데이터가 사용자가 Double Click한 라인의 데이터가 된다.
    READ TABLE gt_display INTO gs_display INDEX e_row-index.

    IF sy-subrc EQ 0.

*     READ 에 성공하면, GS_DISPLAY 는 사용자가 Double Click한 데이터를 가지고 있다고 볼 수 있다.

*     Double Click한 라인은 체크, 아이콘, 색상 처리를 한다.
      gs_display-my_chkbox    = abap_on.
      gs_display-my_icon      = icon_checked.
      gs_display-my_row_color = 'C310'. " 색상(C) 노란색(3) 진한(1) 배경(0)


*     ITAB 에서 DOUBLE CLICK 했던 라인의 모든 데이터 중에서
*     ROW_COLOR만 GS_DISPLAY에서 값을 가져와 변경한다.
      MODIFY gt_display FROM gs_display
                        INDEX e_row-index
                        TRANSPORTING my_chkbox my_icon my_row_color .


*     LV_CARRID 는 현재 더블 클릭한 라인의 항공사ID를 가지고 있다.
*     예로 AA 항공사의 라인을 DoubleClick 하면 LV_CARRID 에는 'AA' 가 기록되고
*     또는 LH 항공사의 라인을 DoubleClick 하면 LV_CARRID 에는 'LH' 가 기록된다.
      lv_carrid = gs_display-carrid.

*     MODIFY GT_DISPLAY             => Internal Table인 GT_DISPLAY의 데이터를 수정하는 명령
*       FROM GS_DISPLAY             => 변경할 데이터를 가지고 있는 Work Area
*       TRANSPORTING ROW_COLOR      => 변경할 데이터 중에 ROW_COLOR 필드만 변경하겠다.
*       WHERE CARRID EQ LV_CARRID   => 변경할 데이터는 CARRID가 LV_CARRID와 동일한 데이터만 변경하겠다.

*     GS_DISPLAY의 모든 필드를 초기화
      CLEAR gs_display.

*     [ GT_DISPLAY ] 에서 내가 더블클릭한 라인의 항공사ID와 다른 데이터들은 ( WHERE )
*     my_chkbox, my_icon, my_row_color에 대해서 ( TRANSPORTING )
*     [ GS_DISPLAY ]의 값으로 변경된다. ( FROM )
      MODIFY gt_display FROM gs_display
                        TRANSPORTING my_chkbox
                                     my_icon
                                     my_row_color
                        WHERE carrid NE lv_carrid.


*     내가 더블클릭한 라인의 항공사ID 값을 이용해 Database SCARR에서 검색하여 Dictionary Structure SCARR에 보관한다.
      CLEAR gs_carr.
      READ TABLE gt_carr INTO gs_carr WITH TABLE KEY carrid = lv_carrid.

      scarr = CORRESPONDING #( gs_carr ).

*      SELECT SINGLE *
*        FROM scarr                " <-- Database Table SCARR
*        INTO scarr                " <-- TOP에서 선언한 Dictionary Structure SCARR ( TABLES SCARR )
*       WHERE carrid EQ lv_carrid.

*     TOP에서도 적어놨지만, 100 번 화면은 Database Table SCARR로 Input 필드를 생성했으므로,
*     100 번 화면이 새롭게 그려질 때
*     SELECT 로 인해 변경된 Dictionary Structure SCARR 의 값이
*     화면이 새로고침 될 때마다 사용되어 출력된다.

*     이를 위해 현재 화면을 버리고, 화면이 새롭게 그려지도록 한다.
*     현재 화면을 버린다. 그러면 무슨 화면을 보여줘할까? ==>> 현재 화면의 Next Screen 으로 출력된다.
      LEAVE SCREEN.

    ENDIF.

  ENDMETHOD.
*--------------------------------------------------------------------*
* Method ON_DOUBLE_CLICK 끝
*--------------------------------------------------------------------*
ENDCLASS.
