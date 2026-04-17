PROCESS BEFORE OUTPUT.
  MODULE status_0100.

* Subscreen 101을 현재 화면에 불러오는 로직
  CALL SUBSCREEN suba_1 " SUBA1 영역에 Subscreen 호출
       INCLUDING sy-repid '0101'.

* Subscreen 102을 현재 화면에 불러오는 로직
  CALL SUBSCREEN suba_2
       INCLUDING sy-repid '0102'.

PROCESS AFTER INPUT.

  MODULE exit AT EXIT-COMMAND.

  CALL SUBSCREEN suba_1. " 0101번 화면의 PAI 호출


  CALL SUBSCREEN suba_2. " 0102번 화면의 PAI 호출


  MODULE user_command_0100.
