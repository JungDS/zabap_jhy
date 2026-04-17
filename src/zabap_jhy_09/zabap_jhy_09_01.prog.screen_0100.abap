*---------------------------------------------------------------
* PBO (Process Before Output)
* - 화면이 사용자에게 표시되기 직전에 수행되는 이벤트
* - 화면 초기화 및 UI 구성 로직을 처리
*---------------------------------------------------------------
PROCESS BEFORE OUTPUT.

  MODULE status_0100.
* PF-STATUS 설정 (GUI Status)
* - 툴바 버튼, 메뉴 상태 정의
* - SET PF-STATUS / SET TITLEBAR 등이 보통 여기서 수행됨

  MODULE init_alv_0100.
* ALV 및 컨테이너 초기화
* - Custom Container 생성
* - ALV Grid 생성 및 데이터 바인딩
* - 일반적으로 IF go_container IS INITIAL 조건으로 1회만 생성

  MODULE clear_ok_code.
* OK_CODE 초기화
* - 이전 사용자 입력(버튼 클릭 등) 값을 제거
* - 동일 이벤트가 반복 실행되는 것을 방지

*---------------------------------------------------------------
* PAI (Process After Input)
* - 사용자의 입력(버튼, Enter 등) 이후 실행되는 이벤트
* - 사용자 액션 처리 및 로직 분기 수행
*---------------------------------------------------------------
PROCESS AFTER INPUT.

  MODULE exit AT EXIT-COMMAND.
* 종료 처리 (EXIT-COMMAND 전용)
* - EXIT / CANCEL 버튼 처리
* - LEAVE PROGRAM 또는 LEAVE TO SCREEN 0 수행
* - AT EXIT-COMMAND: 종료 관련 OK_CODE만 먼저 처리

  MODULE user_command_0100.
* 일반 사용자 명령 처리
* - OK_CODE 기반으로 CASE 처리
* - 조회, 저장, 버튼 클릭 등의 비즈니스 로직 수행
