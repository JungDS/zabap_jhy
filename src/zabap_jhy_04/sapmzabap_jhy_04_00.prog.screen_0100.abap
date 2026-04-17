PROCESS BEFORE OUTPUT.

* GUI TITLE & STATUS ( 뒤로가기 )
  MODULE status_0100.

* Status Icon을 화면에 생성시키기 위한 모듈
  MODULE set_icon_0100.

* OK_CODE 초기화
  MODULE clear_ok_code.

PROCESS AFTER INPUT.
* 뒤로가기 눌렀을 때 LEAVE TO SCREEN 0 실행되도록
* USER_COMMAND에 로직을 구현한다.
  MODULE user_command_0100.

* 사용자가 입력한 항공사 기준으로 항공사명을 조회한다.
  MODULE select_carrier_name.
