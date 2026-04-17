*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_04
*&---------------------------------------------------------------------*
*& Internal Table 연습 - Local Table Type, Header Line
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_04.


* Local Table Type 이용한 Internal Table 생성
* Header Line 있는 경우
* 임의의 데이터를 Internal Table에 추가 및 출력

* Local Type 중 Structure Type을 선언
TYPES BEGIN OF s_type.
TYPES   num   TYPE c LENGTH 06.
TYPES   name  TYPE c LENGTH 10.
TYPES   phone TYPE c LENGTH 15.
TYPES END OF s_type.

* Chained Statement 사용해서 깔끔하게 표현하기
TYPES: BEGIN OF s_type_2,
         num   TYPE c LENGTH 06,
         name  TYPE c LENGTH 10,
         phone TYPE c LENGTH 15,
       END OF s_type_2.


* Header Line을 가진 Internal Table 선언
DATA itab TYPE STANDARD TABLE OF s_type

               " Internal Table의 Key Field 지정
               " 위에서 지정된 타입( S_TYPE을 사용함 )에 존재하는 필드만 선택이 가능함
               " 3개 필드 중 데이터 구별이 가능하면서 가장 적은 개수의 필드로 구성하는 게 베스트다.
               WITH NON-UNIQUE KEY num

               " 동일한 이름의 Structure 변수도 생성시키는 옵션
               WITH HEADER LINE.


CLEAR itab. " Structure 변수 초기화
CLEAR itab[]. " Internal Table 변수 초기화


* - 을 가운데 둘 경우
* 좌측은 Structure, 우측은 그 Structure의 필드
itab-num   = '0001'.
itab-name  = '홍길동'.
itab-phone = '010-1111-1111'.

* 위와 같이 데이터가 저장된 Structure를
* Internal Table에 한 줄 추가하고 싶을 때
* APPEND 또는 INSERT 키워드를 사용할 수 있다.

APPEND itab. " Structure ITAB에 있는 한 줄을 Internal Table ITAB의 마지막에 한 줄 추가하게 된다.

* 현재 ITAB에는
* NUM   에는 '0001'          이
* NAME  에는 '홍길동'        이
* PHONE 에는 '010-1111-1111' 이 저장되어 있다.
* 이 상황에서 한번 더 APPEND를 실행하면 '0001' / 홍길동 / '010-1111-1111'이 두 줄이 된다.
APPEND itab.


* ITAB에 있는 모든 정보를 출력하고 싶을 때
* WRITE 문을 이용하는 방법

LOOP AT itab. " ITAB 에서 Structure로 한줄씩
  WRITE / itab-num. " 여기서의 ITAB은 Structure
  WRITE   itab-name.
  WRITE   itab-phone.
  ULINE.
ENDLOOP.
