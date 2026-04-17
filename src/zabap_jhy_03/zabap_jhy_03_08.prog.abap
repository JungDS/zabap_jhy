*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_08
*&---------------------------------------------------------------------*
*& 입력값 점검 ( Domain Fixed Value )
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_08.


* Domain S_CLASS 는 Fixed Single Value가 지정되어 있다.
* C = Business Class
* Y = Economy Class
* F = First Class

* 위의 Domain S_CLASS는 Data Element S_CLASS에서만 사용되고 있다.

* Data Element S_CLASS 는 다양한 곳에서 사용되고 있음을 확인했고,
* 그 중에 Tranparent Table SBOOK에서 CLASS 필드의 타입으로
* Data Element S_CLASS를 사용하고 있었다.

* VALUE CHECK가 적히면 아래 과정을 통해 Input 값을 검사한다.
* 1. 관련된 Domain에 설정된 값제한을 검사한다.
* 2. 관련된 Check Table 기준으로 검사한다.
PARAMETERS PA_CLASS TYPE SBOOK-CLASS VALUE CHECK OBLIGATORY.


* C or Y or F 를 입력하고 실행하지 않으면 아래 문장이 출력되지 않는다.
WRITE '성공적으로 실행됨'.
