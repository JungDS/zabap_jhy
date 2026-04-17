*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_09_01_SCR
*&---------------------------------------------------------------------*

* TEXT-S01 : Selection Options
* TEXT-S02 : Departure Options
* TEXT-S03 : Destination Options ( No Intervals 옵션 적용 )

* Subscreen 1100 정의
* 메인 화면(Screen 0100 등)에 포함되어 사용되는 입력 영역
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.

** 전체를 하나의 Block으로 묶을 수도 있으나, 현재는 개별 Block으로 구성
**SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01.

* 기본 조회 조건 (항공사 / 연결편)
* select-options는 단일값 + 범위 + 다중값 입력이 가능한 입력 필드!
  SELECT-OPTIONS: so_car FOR spfli-carrid,   " 항공사 코드
                  so_con FOR spfli-connid.  " 항공편 연결번호

* 화면 간격 조정 (한 줄 공백)
  SELECTION-SCREEN SKIP.

* 출발지 관련 조건 Block
  SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-s02.

* 출발 국가 / 도시 / 공항
* 범위 입력 가능 (예: 여러 국가 선택 가능)
    SELECT-OPTIONS: so_cntf FOR spfli-countryfr, " 출발 국가
                    so_citf FOR spfli-cityfrom,  " 출발 도시
                    so_airf FOR spfli-airpfrom.  " 출발 공항

  SELECTION-SCREEN END OF BLOCK b02 .

  SELECTION-SCREEN SKIP.

* 도착지 관련 조건 Block
* no intervals 옵션 → 단일값 또는 다중 선택만 가능 (범위 입력 금지)
  SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE TEXT-s03 NO INTERVALS.

* 도착 국가 / 도시 / 공항
* 범위 입력은 불가능 (LOW 값만 사용)
    SELECT-OPTIONS: so_cntt FOR spfli-countryto, " 도착 국가
                    so_citt FOR spfli-cityto,    " 도착 도시
                    so_airt FOR spfli-airpto.    " 도착 공항

  SELECTION-SCREEN END OF BLOCK b03.

**SELECTION-SCREEN END OF BLOCK b01.

* Subscreen 1100 종료
SELECTION-SCREEN END OF SCREEN 1100.
