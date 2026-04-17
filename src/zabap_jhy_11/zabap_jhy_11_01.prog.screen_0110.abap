PROCESS BEFORE OUTPUT.
* MODULE STATUS_0110.
  MODULE set_cursor_0110.
  MODULE modify_screen_0110.
*
PROCESS AFTER INPUT.
* MODULE USER_COMMAND_0110.

  FIELD ztjhy_shop-shpnm MODULE check_shpnm.

  FIELD ztjhy_shop-telno MODULE check_telno ON REQUEST.
