*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_02
*&---------------------------------------------------------------------*
*& ALV Grid 예제 ( Field Catalog + Event ) 기초
*&
*& 개발 순서
*& 1.    INCLUDE 프로그램을 생성한다.
*&        - TOP, SCR, CLS, PBO, PAI, F01
*& 2.    ABAP EVENT를 정의한다.
*&        - INITIALIZATION, AT SELECTION-SCREEN, START-OF-SELECTION
*& 3.    TOP 에서 사용할 변수를 정의한다.
*&        - 이 프로그램에 필요할 것으로 생각되는 변수를 정의한다.
*& 4.    SCR 에서 Selection Screen을 구성한다.
*&        - 누락된 변수가 있으면 TOP 에 가서 변수 선언도 해준다.
*&
*& 5.    ABAP EVENT를 구현한다.
*& 5-1.    [ INITIALIZATION             ] 에서 Selection Screen의 변수나 전역변수의 초기값을 지정한다.
*& 5-2.    [ AT SELECTION-SCREEN        ] 이나
*&         [ AT SELECTION-SCREEN OUTPUT ] 에서 Selection Screen에 대한 PBO, PAI를 정의한다.
*& 5-3.    [ START-OF-SELECTION         ] 을 구현한다.
*& 5-3-1.    데이터 조회하는 과정을 구현한다.
*& 5-3-2.    가져온 데이터를 수정하는 과정을 구현한다.
*& 5-3-3.    편집된 데이터를 출력하기 위해 0100 번 화면을 호출한다.
*&
*& 6.    화면 100을 생성한다.
*& 7.    화면 100의 PBO에서 GUI Status를 생성하고, [ BACK ] , [ EXIT ] , [ CANC ] 를 정의한다.
*& 8.    화면 100의 PAI에서 Module [ EXIT ] 와 [ USER_COMMAND_0100 ]를 생성하고, Function에 대한 기능을 구현한다.
*& 9.    화면 100이 잘 작동하는지 확인한다. ( [ BACK ] , [ EXIT ], [ CANC ] 모두 확인 필요 )
*&
*& 10.   화면 100에 ALV 를 출력하기 위해 [ Custom Control ]을 그린다.
*& 11.   TOP 에서 [ Custom Control ]에 ALV를 연결하기 위해 관련된 참조변수를 선언한다.
*& 12.   화면 100의 PBO에서 다음과 같은 과정을 거친다.
*& 12-1.     참조변수를 통해 객체를 생성한다.
*& 12-2.     ALV 의 [ Layout ], [ Field Catalog ] 등 관련된 내용을 하나씩 설정하여 ALV에게 전달한다.
*& 12-3.     화면에 ALV가 올바르게 출력되었는지 확인한다.
*&
*& 13.   ALV 이벤트를 위해 로컬 클래스를 정의&구현한다.
*& 14.   ALV 이벤트의 작동을 위해 SET HANDLER 로 [ Event Handler Method ]를 등록한다.
*& 15.   ALV 이벤트가 잘 작동하는지 확인한다.
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_02 MESSAGE-ID zabap_jhy_msg.

INCLUDE zabap_jhy_07_02_top. " 전역변수
INCLUDE zabap_jhy_07_02_scr. " Selection Screen
INCLUDE zabap_jhy_07_02_cls. " Local Class ( ALV Event )
INCLUDE zabap_jhy_07_02_pbo. " Process Before Output
INCLUDE zabap_jhy_07_02_pai. " Process After Input
INCLUDE zabap_jhy_07_02_f01. " FORM Subroutines

INITIALIZATION.

AT SELECTION-SCREEN. " Selection Screen의 PAI를 구현

*  CASE SY-UCOMM.
*    WHEN 'ONLI'. " <-- 1000 화면에서 실행버튼을 누른 경우 ONLINE 의 앞 4글자만 따옴
**     실행버튼을 누르셨습니다. 검색이 시작되고, 결과가 화면에 ALV로 출력됩니다.
*      MESSAGE TEXT-M01 TYPE 'I'.
*  ENDCASE.

START-OF-SELECTION.

  PERFORM select_data.
  PERFORM make_display_data.
  PERFORM display_data.
