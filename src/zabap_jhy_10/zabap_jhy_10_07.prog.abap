*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_10_07
*&---------------------------------------------------------------------*
*& CORRESPONDING #( ) 문법 + MAPPING
*&---------------------------------------------------------------------*
REPORT zabap_jhy_10_07.

" 필드명을 다르게 바꾼 Structure 타입 선언
TYPES: BEGIN OF ty_connection,
         airline_id    TYPE spfli-carrid,
         connection_id TYPE spfli-connid,
         from_city     TYPE spfli-cityfrom,
         to_city       TYPE spfli-cityto,
         distance      TYPE spfli-distance,
         distance_unit TYPE spfli-distid,
       END OF ty_connection.

START-OF-SELECTION.

* SPFLI와 동일한 필드명을 가진 Structure 변수 선언
  DATA(ls_spfli) = VALUE spfli( carrid   = 'LH'
                                connid   = '0400'
                                cityfrom = 'FRANKFURT'
                                cityto   = 'NEW YORK'
                                distance = 6200
                                distid   = 'KM' ).

* MAPPING: 대상필드 = 소스필드 형태로 매핑 지정
* 유일하게 distance 만 이름이 동일하고, 나머지가 전부 다르다.
* 이름이 달라도 CORRESPONDING 으로 값을 전달하기 위해 [ MAPPING ] 을 사용했다.
  DATA(ls_connection) = CORRESPONDING ty_connection( ls_spfli MAPPING airline_id    = carrid
                                                               connection_id = connid
                                                               from_city     = cityfrom
                                                               to_city       = cityto
                                                               distance_unit = distid ).

  WRITE: / 'airline_id    :', ls_connection-airline_id,
         / 'connection_id :', ls_connection-connection_id,
         / 'from_city     :', ls_connection-from_city,
         / 'to_city       :', ls_connection-to_city,
         / 'distance      :', ls_connection-distance,
         / 'distance_unit :', ls_connection-distance_unit.
