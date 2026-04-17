*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_01_06.

TABLES SFLIGHT.

DATA SCARR TYPE SCARR.

* SCARR를 동일하게 사용해서 선언
SCARR-CARRID   = 'AA'.
SCARR-CARRNAME = '미국 항공사'.

WRITE: / SCARR-CARRID,
         SCARR-CARRNAME.

* TABLES로 선언해도 Structure 변수라 볼 수 있다.
SFLIGHT-CARRID   = 'AA'.
SFLIGHT-CONNID   = '0017'.
SFLIGHT-FLDATE   = '20240101'.
SFLIGHT-SEATSMAX = 200.
SFLIGHT-SEATSOCC = 150.

WRITE :/ SFLIGHT-CARRID,
         SFLIGHT-CONNID,
         SFLIGHT-FLDATE,
         SFLIGHT-SEATSMAX,
         SFLIGHT-SEATSOCC.
