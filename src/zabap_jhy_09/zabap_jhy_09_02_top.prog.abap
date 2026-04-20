*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_TOP
*&---------------------------------------------------------------------*

* Selection Screen 및 테이블 참조 선언
* sscrfields : Selection Screen의 OK_CODE 및 사용자 입력 상태를 제어하기 위한 구조
* spfli      : SAP 표준 항공편 정보 테이블 (예제 데이터용)
TABLES: sscrfields,
        spfli.

* 단일 데이터 처리용 구조 (Work Area)
* spfli 테이블의 한 건(row)을 담기 위한 구조
DATA: gs_data TYPE spfli,

* 여러 건 데이터 처리용 Internal Table
* gs_data와 동일한 구조를 가지는 테이블
      gt_data LIKE TABLE OF gs_data.

* ALV 출력용 구조 정의
* 기존 gs_data 구조를 포함하면서, 화면 출력용으로 확장 가능하도록 별도 구조 생성
DATA: BEGIN OF gs_display.
        INCLUDE STRUCTURE gs_data. " 기존 데이터 구조 포함
DATA: END OF gs_display.

* ALV Grid에 출력할 데이터 Internal Table
DATA: gt_display LIKE TABLE OF gs_display.

* 현재 화면(Screen) 번호를 저장
* CALL SCREEN 또는 화면 전환 시 사용
DATA: gv_dynnr TYPE sy-dynnr.

*--------------------------------------------------------------------*
* Screen 공용
*--------------------------------------------------------------------*

* 사용자 액션(버튼 클릭 등)을 처리하기 위한 OK_CODE
* PAI(Process After Input)에서 사용
DATA: ok_code TYPE sy-ucomm.

*--------------------------------------------------------------------*
* Screen 0100
*--------------------------------------------------------------------*

* Custom Container 객체
* 화면(Screen 0100)에 ALV를 출력하기 위한 컨테이너
DATA: go_container TYPE REF TO cl_gui_custom_container,

* ALV Grid 객체
* 실제 데이터를 테이블 형태로 화면에 출력하는 객체
      go_alv_grid  TYPE REF TO cl_gui_alv_grid.

* ALV Variant 설정
* 사용자가 저장한 레이아웃(컬럼 순서, 필터 등)을 불러오기 위한 구조
DATA: gs_variant  TYPE disvariant,

* ALV 레이아웃 저장 가능 여부 설정
* 'A' : 사용자별/전체 저장 모두 허용
      gv_save     TYPE c VALUE 'A',

* ALV 화면 레이아웃 설정 (Zebra, 컬럼폭 자동조정 등)
      gs_layout   TYPE lvc_s_layo,

* Field Catalog (ALV 컬럼 속성 정의)
* 어떤 필드를 어떻게 보여줄지 정의하는 핵심 구조
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,

* Sort 설정 (정렬 기준)
* ALV에서 특정 컬럼 기준으로 정렬하기 위한 설정
      gt_sort     TYPE lvc_t_sort,
      gs_sort     TYPE lvc_s_sort.

* ALV 출력 데이터 건수
* 데이터 건수 체크 또는 화면 표시용으로 사용
DATA: gv_lines    TYPE i.
