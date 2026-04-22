*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_12
*&---------------------------------------------------------------------*
*& Internal Table 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_12.

" 내부테이블 한 줄(라인) 구조 정의
TYPES: BEGIN OF ty_student,
         student_id TYPE n LENGTH 8,
         student_nm TYPE c LENGTH 20,
         major      TYPE c LENGTH 20,
       END OF ty_student.

" 내부테이블(여러 건 저장), Work Area(한 건 처리)
DATA gt_student TYPE STANDARD TABLE OF ty_student WITH EMPTY KEY.
DATA gs_student TYPE ty_student.

START-OF-SELECTION.
  " 5건 데이터 APPEND
  gs_student-student_id = '20260001'. gs_student-student_nm = '김하나'. gs_student-major = '회계'. APPEND gs_student TO gt_student.
  gs_student-student_id = '20260002'. gs_student-student_nm = '이둘'.   gs_student-major = '물류'. APPEND gs_student TO gt_student.
  gs_student-student_id = '20260003'. gs_student-student_nm = '박셋'.   gs_student-major = '생산'. APPEND gs_student TO gt_student.
  gs_student-student_id = '20260004'. gs_student-student_nm = '최넷'.   gs_student-major = '인사'. APPEND gs_student TO gt_student.
  gs_student-student_id = '20260005'. gs_student-student_nm = '정다섯'. gs_student-major = '영업'. APPEND gs_student TO gt_student.

  WRITE: / '===== 내부테이블 데이터 출력 ====='.
  WRITE: / '내부테이블은 "여러 건 데이터"를 메모리에 저장하는 구조입니다.'.
  SKIP.

  " LOOP AT ... INTO: 내부테이블을 한 줄씩 Work Area로 읽는다.
  LOOP AT gt_student INTO gs_student.
    WRITE: / 'INDEX:', sy-tabix,
             '학번:', gs_student-student_id,
             '이름:', gs_student-student_nm,
             '전공:', gs_student-major.
  ENDLOOP.
