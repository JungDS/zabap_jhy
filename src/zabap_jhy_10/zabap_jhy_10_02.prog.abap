*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_02
*&---------------------------------------------------------------------*
*& VALUE #() 문법 기초
*& Structure 구조의 값을 직접 표현하는 방법
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_02.

START-OF-SELECTION.

*--------------------------------------------------------------------*
* 예시를 위한 Type 선언
*--------------------------------------------------------------------*
  TYPES: BEGIN OF ty_emp,
           empno TYPE i,       " 사번
           name  TYPE string,  " 직원명
           dept  TYPE string,  " 부서 코드
         END OF ty_emp.

  TYPES ty_emp_tab TYPE TABLE OF ty_emp WITH EMPTY KEY.

*--------------------------------------------------------------------*
* Structure 값 설정
*--------------------------------------------------------------------*

* Structure 변수 선언 + VALUE #( )로 필드의 값 지정
  DATA(ls_emp) = VALUE ty_emp(
    empno = 1001
    name  = '정훈영'
    dept  = 'MM'
  ).

*--------------------------------------------------------------------*
* Internal Table 값 설정
*--------------------------------------------------------------------*

* Internal Table 변수 선언 + VALUE #( )로 데이터 3줄 생성
  DATA(lt_emp) = VALUE ty_emp_tab(
    ( empno = 1001 name = '정훈영' dept = 'MM' )
    ( empno = 1002 name = '홍길동' dept = 'PP' )
    ( empno = 1003 name = '이몽룡' dept = 'SD' )
  ).

*--------------------------------------------------------------------*
* BASE로 기존 값 유지 + 일부만 변경
*--------------------------------------------------------------------*

* Structure 변수 선언 + LS_EMP 기준에서 DEPT 필드만 값 변경하여 전달
* - LS_EMP에서 변경되지 않은 [ EMPNO, NAME ]은 [ 1001, '정훈영' ]으로 전달
  DATA(ls_emp2) = VALUE ty_emp( BASE ls_emp   " 기준값 설정
                                dept = 'CO'   " 기준값 에서 변경할 값
                              ).

* Internal Table 변수 선언 + LT_EMP의 데이터와 2줄의 데이터를 모두 전달
* - LT_EMP 에는 3줄이 있었기 때문에 총 5줄이 전달
  DATA(lt_emp2) = VALUE ty_emp_tab( BASE lt_emp   " 기준 3행
    ( empno = 2001 name = '흥부' dept = 'CO' )    " 추가  행
    ( empno = 2002 name = '놀부' dept = 'FI' )    " 추가  행 => 총 5행 전달
  ).


*--------------------------------------------------------------------*
* 실무에서 많이 쓰이는 구문
*--------------------------------------------------------------------*
  DATA r_carrid TYPE RANGE OF scarr-carrid. " Range 변수 선언

* Range 변수에 조건 데이터 설정
* 1. LH 와 동일한 값 포함
* 2. AA 부터 DL 사이의 값 포함
* 3. 모든 포함결과에서 AZ 는 제외
  r_carrid = VALUE #(
    ( sign = 'I' option = 'EQ' low = 'LH' )               " 포함(I) / 같음(EQ) / LH
    ( sign = 'I' option = 'BT' low = 'AA' high = 'DL' )   " 포함(I) / 범위(BT) / AA ~ DL
    ( sign = 'E' option = 'EQ' low = 'AZ' )               " 제외(E) / 같음(EQ) / AZ
  ).

* Range 변수는 아래와 같이 OpenSQL 등에서 사용가능하다.
* 예: SELECT ... WHERE carrid IN r_carrid
