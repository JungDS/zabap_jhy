*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_11
*&---------------------------------------------------------------------*
*& Structure / Work Area 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_11.

" 구조(Structure): 관련 필드를 한 묶음으로 정의한 '한 건 레코드' 타입
TYPES: BEGIN OF ty_employee,
         empno      TYPE n LENGTH 8,    " 사번
         ename      TYPE c LENGTH 20,   " 이름
         dept       TYPE c LENGTH 20,   " 부서
         hire_date  TYPE d,             " 입사일
         salary     TYPE p LENGTH 8 DECIMALS 2, " 급여
       END OF ty_employee.

" Work Area: 구조 타입의 실제 데이터 저장 공간 (한 건)
DATA gs_employee TYPE ty_employee.

START-OF-SELECTION.
  " Work Area에 값 할당
  gs_employee-empno = '20260001'.
  gs_employee-ename = '이신입'.
  gs_employee-dept = 'FI'.
  gs_employee-hire_date = '20260301'.
  gs_employee-salary = '3500000.50'.

  WRITE: / '===== 직원 1건 데이터 출력 ====='.
  WRITE: / '사번     :', gs_employee-empno.
  WRITE: / '이름     :', gs_employee-ename.
  WRITE: / '부서     :', gs_employee-dept.
  WRITE: / '입사일   :', gs_employee-hire_date.
  WRITE: / '급여     :', gs_employee-salary.

  SKIP.
  WRITE: / '※ 구조(Structure) + Work Area는 "한 건 데이터"를 다룰 때 사용합니다.'.
