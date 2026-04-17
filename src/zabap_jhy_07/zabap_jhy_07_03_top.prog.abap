*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_TOP
*&---------------------------------------------------------------------*


DATA gt_carr TYPE TABLE OF scarr WITH KEY carrid.
DATA gs_carr TYPE scarr.

DATA gt_pfli TYPE TABLE OF spfli. " <-- Database 에서 검색결과를 담아둘 itab
DATA gs_pfli LIKE LINE OF gt_pfli.

DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_pfli.
DATA:
*       화면에 보이는 신규 출력필드 추가
        my_chkbox,

*       화면에 보이는 아이콘을 위한 필드
        my_icon      TYPE icon-id,

*       화면에 안보이는 색상을 위한 필드 ( 행단위, 셀단위 )
        my_row_color TYPE char4, " C + ### 색상을 처리
*                                       #   : 0 ~ 7 , 8가지 색상
*                                        #  : 1 강조(진하게), 0 연하게
*                                         # : 0 배경, 1 글자
*                                      C310 : 진한 노란색을 배경으로 색상

      END OF gs_display.

DATA: gt_display LIKE TABLE OF gs_display. " <-- ALV 에서 데이터를 출력할 itab


* 사용자가 뒤로가기 같은 버튼을 누를 때 관련 Function Code 값이 기록되는 변수
* 이 변수에 BACK 이라는 문자열이 생기면, 사용자가 뒤로가기 버튼을 누른 거고
* 이 변수에 EXIT   라는 문자열이 생기면, 사용자가 나가기   버튼을 누른 거고
* 이 변수에 CANC   라는 문자열이 생기면, 사용자가 취소하기 버튼을 누른 거다.
DATA ok_code TYPE sy-ucomm.

* 100 번 화면과 데이터를 주고 받기 위한 Dictionary Structure
* 이 변수에 값이 들어가면 화면에도 동일한 값이 보이고,
* 화면에서 새로운 값으로 내가 입력할 수만 있다면, 해당하는 값이 이 변수에 기록된다.
TABLES scarr.

* Custom Control Area는 화면 안에 특정 공간을 차지하는데,
* 그 공간에 Custom Container 를 연결할 수 있다.
* 그리고 Custom Container 에는 ALV Grid 가 출력될 수 있다.
DATA go_container TYPE REF TO cl_gui_custom_container.
DATA go_alv_grid TYPE REF TO cl_gui_alv_grid.

* ALV 의 레이아웃 설정 을 위한 변수 선언
DATA gs_layout TYPE lvc_s_layo.

* ALV 의 Field Catalog 를 위한 변수 선언
DATA gt_fieldcat TYPE lvc_t_fcat.
DATA gs_fieldcat TYPE lvc_s_fcat.


* LCL_EVENT_HANDLER 의 Instance Method를 다루기 위해 참조변수를 선언한다.
* 단, LCL_EVENT_HANDLER 를 TOP 다음에 CLS 에서 정의하기 때문에
* 현재 시점에서는 LCL_EVENT_HANDLER 라는 클래스를 전혀 모른다.
* 그러므로, LCL_EVENT_HANDLER 라는 클래스가 이후에 선언된다는 것을 알려주기 위해
* 다음과 같이 클래스 선언이 지연되었음을 알려준다.
CLASS lcl_event_handler DEFINITION DEFERRED.
DATA go_event_handler TYPE REF TO lcl_event_handler.
