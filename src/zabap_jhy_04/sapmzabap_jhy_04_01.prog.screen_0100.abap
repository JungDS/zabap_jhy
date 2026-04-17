PROCESS BEFORE OUTPUT.

* Status 설정을 통해 Standard Toolbar 에서
* Back, Exit, Cancel 버튼을 활성화
  MODULE STATUS_0100.

* GV_MODE 가 1 일 때는 열림
* GV_MODE 가 0 일 때는 잠금
  MODULE MODIFY_SCREEN_0100.


PROCESS AFTER INPUT.

* 사용자가 Exit 또는 Cancel 버튼을 누른 경우 해당 로직처리
  MODULE EXIT_0100 AT EXIT-COMMAND.

* 사용자가 Back키를 누른 경우 이전화면 이동로직 처리
* 사용자가 Push Button을 누른 경우 GV_MODE을 0 or 1로 변경

  MODULE USER_COMMAND_0100.
