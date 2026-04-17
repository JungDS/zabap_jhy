PROCESS BEFORE OUTPUT.
  MODULE status_0100.
  MODULE clear_ok_code.

PROCESS AFTER INPUT.

* PAI 종료 기능 수행 ( 종료하기, 취소하기 )
  MODULE exit AT EXIT-COMMAND.

* 입력값 점검

* 1. 일자들 점검
  CHAIN.
    FIELD: ztjhy_student-bdate, " 생일
           ztjhy_student-adate, " 입학일자
           ztjhy_student-gdate. " 종료일자

    MODULE check_date ON CHAIN-REQUEST.
  ENDCHAIN.

* 2. 학과 점검
  FIELD ztjhy_student-dptcd MODULE check_dptcd ON REQUEST.



* 입력값 점검이 올바르면 PAI 일반 기능 수행( 저장, 뒤로가기 )
  MODULE user_command_0100.
