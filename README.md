# zabap_jhy

## 저장소 성격
`zabap_jhy`는 ABAP 실습 코드를 단계별로 정리한 학습형 레포지토리입니다. `src` 아래의 `zabap_jhy_01`~`zabap_jhy_11` 폴더가 각각 하나의 학습 단원을 구성합니다.

## src 폴더 한눈에 보기
| 폴더 | .abap 수 | 핵심 키워드 |
|---|---:|---|
| `zabap_jhy_01` | 13 | 타입/변수, Internal Table, 기본 SELECT |
| `zabap_jhy_02` | 14 | IF/CASE/DO/WHILE, 문자열 처리(SPLIT), 메시지 |
| `zabap_jhy_03` | 11 | Selection Screen 구성/이벤트 |
| `zabap_jhy_04` | 35 | Module Pool, PBO/PAI, 화면 제어 |
| `zabap_jhy_05` | 17 | Subroutine, Function Module, OOP/예외 |
| `zabap_jhy_06` | 4 | Open SQL, View vs JOIN, 데이터 복사 |
| `zabap_jhy_07` | 74 | SALV/ALV Grid, Field Catalog, Event |
| `zabap_jhy_08` | 8 | BDC, Number Range, Field-Symbol 동적 처리 |
| `zabap_jhy_09` | 43 | Custom/Docking/Dialog/Splitter Container |
| `zabap_jhy_10` | 9 | 신문법(Inline, VALUE #(), NEW) |
| `zabap_jhy_11` | 39 | 업무형 통합 예제(등록/검증/화면/함수그룹) |

---

## 폴더별 상세 분석

### `src/zabap_jhy_01` — ABAP 기초 문법 + Internal Table 입문
- 예제 흐름: Local/Global Type 비교 → 변수/Structure 선언 → Internal Table 조작.
- `zabap_jhy_01_11.prog.abap`: **Standard/Sorted 테이블 차이**, Radio Button 분기, `CL_DEMO_OUTPUT`/`CL_SALV_TABLE` 출력 비교.
- 주로 `SCARR`, `SPFLI`를 사용해 기본 조회/출력 패턴을 학습.

### `src/zabap_jhy_02` — 제어문/반복문/문자열 처리
- 예제 흐름: 입력값 처리 → IF/CASE → DO/WHILE 반복문.
- `zabap_jhy_02_13.prog.abap`: 조회 데이터 문자열 결합 후 `SPLIT ... INTO TABLE` vs `SPLIT ... INTO` 비교.
- 메시지 타입, 사용자 입력값 기반 분기 처리 연습.

### `src/zabap_jhy_03` — Selection Screen 집중 학습
- `zabap_jhy_03_00`~`03_05`: Block/Line/Pushbutton/User Command 등 화면 요소 구성.
- `zabap_jhy_03_06.prog.abap`: **다중 Selection Screen 생성/호출**(`CALL SELECTION-SCREEN`).
- `zabap_jhy_03_10.prog.abap`: Radio/입력값 조합의 검증 이벤트 처리.

### `src/zabap_jhy_04` — Module Pool(다이얼로그 프로그램)
- `sapmzabap_jhy_04_0x` + `mzabap_jhy_04_0x(top/o01/i01/f01)` 형태로 Include 분리.
- PBO/PAI 중심의 화면 이벤트 처리와 화면 전환 패턴 연습.
- `sapmzabap_jhy_04_05.prog.abap`: 계산기 예제(실제 인터랙션 로직 구현).

### `src/zabap_jhy_05` — Subroutine → Function Module → OOP
- 초반: `PERFORM`/파라미터 전달 방식(Call by value/reference/result) 비교.
- 중반: 함수그룹 `zabap_jhy_05_fg01`의 `Z_ABAP_JHY_CAR_SPEED_*` 함수 모듈 실습.
- 후반: `zcl_jhy_car`, `zcx_jhy_car_model_check`로 생성자/예외/클래스 설계 연습.

### `src/zabap_jhy_06` — Open SQL 실전 패턴
- `zabap_jhy_06_01.prog.abap`: DB View(`SV_FLIGHTS`) 조회.
- `zabap_jhy_06_02.prog.abap`: `SCARR/SPFLI/SFLIGHT` 직접 `JOIN` 조회.
- `zabap_jhy_06_03.prog.abap`: `SCARR -> ZCARR` 복사와 Selection Screen 버튼 제어.

### `src/zabap_jhy_07` — ALV Grid 심화(대규모 Include 구조)
- `zabap_jhy_07_00`: SALV 기본.
- `zabap_jhy_07_01`~`07_08`: Field Catalog/Style/Event/PBO/PAI 등 단계별 ALV Grid 확장.
- `zabap_jhy_07_09`: 포함파일(`_top/_scr/_cls/_pbo/_pai/_f01`)로 분리된 **종합 실습**.

### `src/zabap_jhy_08` — 동적 프로그래밍/운영 유틸 성격 예제
- `zabap_jhy_08_00`: BDC(`CALL TRANSACTION USING`) 실습.
- `zabap_jhy_08_01`: Number Range(`NUMBER_GET_NEXT`) 실습.
- `zabap_jhy_08_06`: 사용자 입력 테이블명 기반 동적 내부테이블 생성(`CREATE DATA ... TYPE TABLE OF (pa_tabnm)`) + SALV 출력.

### `src/zabap_jhy_09` — 컨테이너 기반 UI 컴포넌트 학습
- `zabap_jhy_09_01`: Custom Container.
- `zabap_jhy_09_03`: Docking Container.
- `zabap_jhy_09_04`: Dialog Box Container(팝업형 상세 UI).
- `zabap_jhy_09_05`: Splitter Container 확장 예정 코드.

### `src/zabap_jhy_10` — 신문법(7.4+ 스타일) 학습
- `zabap_jhy_10_00`: Inline 선언.
- `zabap_jhy_10_01`: 객체 생성 방식(`CREATE OBJECT` vs `NEW`).
- `zabap_jhy_10_02`~`10_05`: `VALUE #( )` 활용(구조/테이블/Select-Option 조립).

### `src/zabap_jhy_11` — 업무형 통합 미니 프로젝트
- 업무 도메인: 주변 가게 등록, 학생정보 생성/검증, 부가 검증 함수.
- `zabap_jhy_11_04`, `11_05`: 학생정보 생성 + 반복생성 개선.
- 커스텀 DDIC/객체 다수 포함(`ztjhy_*` 테이블, `zejhy_*` 데이터요소, `zjhystdid` 넘버레인지, `zabap_jhy_11_fg01` 함수그룹).

---

## 전체 학습 경로 요약
1. **기초 문법**: `01`~`03`
2. **화면 프로그래밍**: `04`
3. **절차/함수/OOP 전환**: `05`
4. **SQL/ALV 실무형 확장**: `06`~`10`
5. **통합 업무형 시나리오**: `11`

## 분석 기준
- 본 문서는 `src`의 `.abap` 소스(주석/헤더 설명 포함)를 기준으로 정리했습니다.
- `.xml` 파일은 객체 메타데이터(프로그램/테이블/트랜잭션/사전객체) 확인 용도로만 참고했습니다.
