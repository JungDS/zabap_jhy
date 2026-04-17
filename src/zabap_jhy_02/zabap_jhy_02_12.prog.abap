*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_12
*&---------------------------------------------------------------------*
*& Message 출력 by Message Class
*&---------------------------------------------------------------------*

* 프로그램 바깥에서 생성된 메시지 클래스를 지정하여 사용할 수 있다.
REPORT zabap_jhy_02_12 MESSAGE-ID zabap_jhy_msg.

* 특정 번호의 메시지를 가져와 화면에 출력하는 용도로 사용한다.
MESSAGE i007 WITH sy-datum.


* 메시지 클래스를 관리하는 트랜잭션 코드는 SE91 이다.
* MESSAGE TYPE : S(Success), I(Information), E(Error), W(Warning), A(Abort), X(Exception)


MESSAGE i001 WITH '안녕' '난 안보여'.
MESSAGE i002 WITH '안녕' '난 보여'.
MESSAGE s001(yabap_jhy_msg) WITH '난 다음 화면의 하단에 출력되'.
*
*MESSAGE i007 DISPLAY LIKE 'S' WITH sy-datum .
*MESSAGE i007 DISPLAY LIKE 'W' WITH sy-datum .
*MESSAGE i007 DISPLAY LIKE 'E' WITH sy-datum .
