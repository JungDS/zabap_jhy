PROCESS BEFORE OUTPUT.
  MODULE status_0100.
  MODULE init_alv_0100.

  MODULE fill_dynnr_0100. " Tabstrip의 SubArea을 위한 모듈
  CALL SUBSCREEN sub INCLUDING sy-repid gv_tabstrip_dynnr.

  MODULE clear_ok_code.

PROCESS AFTER INPUT.

* 1순위 Exit Command
  MODULE exit_0100 AT EXIT-COMMAND.

* 2순위 현재 화면에서 사용된 Subscreen의 PAI 호출
  CALL SUBSCREEN sub.

* 3순위 화면 입력값 점검
* FIELD ~~~ MODULE ~~~ [ON REQUEST].
* 또는
* CHAIN.
*   FIELD: ~~~,
*          ~~~.
*   FIELD  ~~~.
*   MODULE CHECK_~~~ [ON CHAIN-REQUEST].
* ENDCHAIN.

* 4순위 Function Code에 대한 처리
  MODULE user_command_0100.
