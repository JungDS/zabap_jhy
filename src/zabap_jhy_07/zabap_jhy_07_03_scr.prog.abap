*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_03_SCR
*&---------------------------------------------------------------------*

* TOP 에서 TABLES SPFLI 를 선언하지 않아서 SPFLI 라는 변수가 없음
* 하지만 GS_PFLI 라는 변수를 선언했기 때문에 그냥 GS_PFLI 로 사용 중
SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-s01. " Selection Options

  SELECT-OPTIONS so_car   FOR gs_pfli-carrid.
  SELECT-OPTIONS so_con   FOR gs_pfli-connid.
  SELECT-OPTIONS so_ctrf  FOR gs_pfli-countryfr.
  SELECT-OPTIONS so_ctrt  FOR gs_pfli-countryto.

SELECTION-SCREEN END OF BLOCK b01.
