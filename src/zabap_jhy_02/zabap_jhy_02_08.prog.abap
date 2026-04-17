*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_08
*&---------------------------------------------------------------------*
*& 조건이 성립할 때만 진행하는 CHECK 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_02_08.



DATA gv_a TYPE c.
DATA gv_b TYPE c.


DATA: BEGIN OF gs_data,
        name TYPE c LENGTH 10,
      END OF gs_data.

DATA gt_data LIKE TABLE OF gs_data.

START-OF-SELECTION.

  gv_a = 'A'.
  gv_b = 'B'.

  WRITE / '안녕? 변수 GV_A에는 ''A''가 담겨있고, 변수 GV_B에는 ''B''가 담겨있어.'.
  ULINE.
  SKIP 2.


* 변수 GV_A와 GV_B를 전달한다.
  PERFORM my_subroutine USING gv_a
                              gv_b.


  PERFORM append USING: '정훈영',
                        '홍길동',
                        '김철수',
                        '이영희',
                        '이몽룡',
                        '성춘향',
                        '놀부',
                        '흥부'.

  ULINE.
  WRITE / '반복문 안에서는 CHECK문의 조건이 성립하지 않으면'.
  WRITE / '반복문을 중단하지 않고, 다음 반복으로 넘어간다.'.
  ULINE.
  LOOP AT gt_data INTO gs_data.

*   문자 '영' 또는 '부'가 포함된 문장만 진행한다. 불일치하면, 다음 반복을 진행한다.
    CHECK gs_data-name CA '영부'.

    WRITE :/ '환영합니다.', gs_data-name COLOR COL_HEADING, '님'.

  ENDLOOP.
  SKIP 2.



  ULINE.
  WRITE / 'START-OF-SELECTION에서는 CHECK문의 조건이 불일치하면 이벤트를 중단하고 다음 이벤트로 이동해'.
  WRITE / '[ CHECK GV_A EQ GV_B ] 문장은 조건이 불일치 하기 때문에 다음 문장을 실행하지 않아.'.
  ULINE.
  SKIP 2.
* 조건이 일치할 때만 진행하고 아니면 중단하는 CHECK문
  CHECK gv_a EQ gv_b.


  WRITE / '이 문장은 CHECK문의 조건이 성립하지 않기 때문에 실행되지 않아.'.

END-OF-SELECTION.

  ULINE.
  WRITE / '나는 START-OF-SELECTION이 종료되면, 실행되는 END-OF-SELECTION이야.'.
  WRITE / '지금까지의 과정을 천천히 살펴보면서 모두 다 이해하길 바래.'.
  ULINE.

*&---------------------------------------------------------------------*
*& Form MY_SUBROUTINE
*&---------------------------------------------------------------------*
FORM my_subroutine USING pv_a TYPE c
                         pv_b TYPE c.
  ULINE.
  WRITE / '서브루틴 안에서는 CHECK가 불일치할 땐, 서브루틴을 종료하고 호출했던 곳으로 돌아가.'.
  ULINE.
  SKIP 2.

  CHECK pv_a EQ pv_b.

  WRITE / '이 문장은 CHECK문의 조건이 성립하지 않기 때문에 실행되지 않아.'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form APPEND
*&---------------------------------------------------------------------*
FORM append  USING pv_name TYPE clike.

  CLEAR gs_data.
  gs_data-name = pv_name.
  INSERT gs_data  INTO TABLE gt_data.

ENDFORM.
