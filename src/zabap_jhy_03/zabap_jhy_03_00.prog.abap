*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_00
*&---------------------------------------------------------------------*
*& Selection Screen 생성 및 Text 적용
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_00.


* 아래 2개의 키워드는 Selection Screen에 입력필드를 생성하는 역할도 갖고 있다.
* PARAMETERS
* SELECT-OPTIONS

* Text Elements에서 Selection Texts 탭에서
* 생성한 [ PARAMETERS ] 나 [ SELECT-OPTIONS ]에게 Text를 적용할 수 있다.

DATA gv_carrid TYPE scarr-carrid.

PARAMETERS pa_car TYPE scarr-carrid.  " 단일값(한칸)을 지닌 변수

SELECT-OPTIONS so_car FOR gv_carrid.  " 4개의 필드를 지닌 Internal Table
*                                       단일값 조회 가능
*                                       범위   조회 가능
*                                       다양한 검색조건   지원
*                                       다중   검색조건값 지원
*                                       비어 있는 경우 전체 검색 지원

*--------------------------------------------------------------------*
TABLES scarr. " 변수 선언
SELECT-OPTIONS so_car2 FOR scarr-carrid. " 변수로 선언했지만, 아닌 것처럼 FAKE
*--------------------------------------------------------------------*
