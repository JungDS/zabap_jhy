*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_03
*&---------------------------------------------------------------------*
*& Structure와 Internal Table 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_01_03.


*--------------------------------------------------------------------*
* 1. ABAP Dictionary 에서 Structure로 선언된 Data Type을 이용한다.
*--------------------------------------------------------------------*
DATA GS_1 TYPE BC400_S_FLIGHT.

*--------------------------------------------------------------------*
* 2. Local Type을 이용해 Structure 를 선언한다.
*--------------------------------------------------------------------*
TYPES: BEGIN OF TS_1,
         CARRID TYPE BC400_S_FLIGHT-CARRID,
       END OF TS_1.

DATA GS_2 TYPE TS_1.

*--------------------------------------------------------------------*
* 3. 변수 선언과 동시에 Structure의 Component를 작성한다.
*--------------------------------------------------------------------*
DATA: BEGIN OF GS_3,
        CARRID  TYPE BC400_S_FLIGHT-CARRID,
        MY_DATA TYPE C LENGTH 10,
      END OF GS_3.



*--------------------------------------------------------------------*
* Internal Table 선언 방법
*--------------------------------------------------------------------*

* 1. ABAP Dictionary 에 있는 Table Type 를 사용하는 방법
DATA GT_1 TYPE BC400_T_FLIGHTS.


* 2. ABAP Dictionary 에 Table Type은 없지만 Structure 가 있는 경우
DATA GT_2 TYPE TABLE OF BC400_S_FLIGHT. " Standard Internal Table ( 약식 표현, 대세 )
DATA GT_3 TYPE STANDARD TABLE OF BC400_S_FLIGHT " Standard Internal Table ( 전체 표현 )
          WITH NON-UNIQUE KEY CARRID CONNID FLDATE. " 중복허용된 키필드 추가 가능


* 3. 프로그램에서 선언한 Structure 변수를 이용해서 Internal Table을 선언하는 방법
DATA GT_4A LIKE TABLE OF GS_1. " 변수 GS_1의 모양으로 여러 줄 쌓을 수 있는 Standard Internal Table이 생성된다.
DATA GT_4B LIKE SORTED TABLE OF GS_1 " Internal Table이 Standard 가 아닌 Sorted 로 선언된다.
           WITH UNIQUE KEY CARRID CONNID FLDATE.    " 중복을 허용하지 않는 키필드로 구성


* 4. 옛문법) Internal Table 선언과 동시에 필드를 구성하는 방법 ( With Header Line )
DATA: BEGIN OF GT_5 OCCURS 0,
        CARRID TYPE BC400_S_FLIGHT-CARRID,
        CONNID TYPE BC400_S_FLIGHT-CONNID,
      END OF GT_5.  " 이 Internal Table은 Field 가 2개 존재한다.
* 이 선언방법은 Internal Table을 반드시 Standard로만 사용이 가능하다. 그리고 Key Field를 지정할 방법이 없다.
* Header Line이 반드시 생기기 때문에 현재는 사용되지 않는다.



***BREAK-POINT. " 디버깅 모드가 아니더라도 이 문장을 만나면, 디버깅 모드가 된다.
***
***GS_1-CARRID = 'AA'.
***GS_1-CONNID = '0017'.
***GS_1-FLDATE = '20201107'.
***
***APPEND GS_1 TO GT_1.
***
***BREAK-POINT. " 디버깅 모드가 아니더라도 이 문장을 만나면, 디버깅 모드가 된다.


* Internal Table과 Work Area를 선언
DATA GT_CARR TYPE TABLE OF SCARR.
DATA GS_CARR TYPE SCARR.

* DB Table에서 Records를 조회해서 Internal Table에 보관
SELECT * FROM SCARR INTO TABLE GT_CARR.

* Internal Table에 보관된 데이터를 한 줄씩 Work Area에 전달하면서 Loop 문 안의 문장을 실행
LOOP AT GT_CARR INTO GS_CARR.
  WRITE : /   GS_CARR-MANDT,
              GS_CARR-CARRID,
              GS_CARR-CARRNAME,
              GS_CARR-CURRCODE,
           40 GS_CARR-URL.
ENDLOOP.
