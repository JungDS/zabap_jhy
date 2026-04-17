PROCESS BEFORE OUTPUT.  " PBO
  MODULE status_0100.
  MODULE init_alv_0100.
  MODULE clear_ok_code.

PROCESS AFTER INPUT.    " PAI

* AT EXIT-COMMAND 가 붙어있는 MODULE은
* 화면에서 필수 입력 점검 등을 무시하며 실행이 된다.

* 이로 인해
* 취소     버튼은 화면에 필수 입력이 비어 있어도 취소되고,
* 뒤로가기 버튼은 화면에 필수 입력이 비어 있으면 작동하지 않는다.
  MODULE exit_0100 AT EXIT-COMMAND.

  FIELD scarr-carrid MODULE check_carrid ON REQUEST.


  MODULE user_command_0100.



PROCESS ON VALUE-REQUEST.
* 직접 Possible Entry 호출을 제어한다.
  FIELD scarr-carrid MODULE f4_carrid.
