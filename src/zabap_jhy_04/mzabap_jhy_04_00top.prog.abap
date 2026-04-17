*&---------------------------------------------------------------------*
*& Include MZABAP_JHY_04_00TOP                      - Module Pool      SAPMZABAP_JHY_04_00
*&---------------------------------------------------------------------*
PROGRAM sapmzabap_jhy_04_00.

* Screen 0100에서 SDYN_CONN을 이용해 입력필드를 만들었다.
* 이 입력필드의 값을 가져오거나, 변경하기 위해서는 Dictionary Structure를 선언해야 한다.
TABLES sdyn_conn.

* Screen 0100의 Element List에서 OK 필드의 이름을 [ OK_CODE ]로 정의한 후
* Status 에서 [ BACK ] 이라는 Function Code를 가진 버튼을 만들었다.

* 이 버튼를 클릭하면, Function Code [ BACK ]가 화면의 OK 필드로 전달되며 PAI 모듈이 실행된다.
* 아래 변수처럼 OK 필드의 이름과 동일한 이름을 가진 변수일 때 PAI 모듈 실행 전 Function Code가 기록된다.
* 위 상황이라면, ok_code 변수에 [ BACK ] 라는 문자가 기록된 후 PAI 모듈이 실행된다고 생각하면 된다.
DATA ok_code TYPE sy-ucomm.


* Status Icon을 위한 변수 선언
* 화면과 동일한 이름, 길이, 타입을 가져야 한다.
DATA iconfield1 TYPE c LENGTH 132.
DATA iconfield2 TYPE c LENGTH 132.
DATA iconfield3 TYPE c LENGTH 132.


* 항공사 이름을 보관하기 위한 변수
DATA gv_carrname TYPE scarr-carrname.
