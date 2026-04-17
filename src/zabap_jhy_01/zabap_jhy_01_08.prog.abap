*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_08
*&---------------------------------------------------------------------*
*& 금액 변수 선언 및 출력 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_01_08.


* 금액은 기본적으로 소수점 2자리로 선언해야 한다.
DATA GV_AMOUNT_P TYPE P DECIMALS 2.

GV_AMOUNT_P = 100. " 정수 100을 기록
WRITE / GV_AMOUNT_P CURRENCY 'KRW'. " 원화 기준으로 출력 ( 10,000 )

GV_AMOUNT_P = '1234.56'. " 실수 1234.56을 기록
WRITE / GV_AMOUNT_P CURRENCY 'KRW'. " 원화 기준으로 출력 ( 123,456 )

* SAP 에서는 소수점 2자리부터 금액을 취급하는데,
* 원화는 소수점 0자리를 사용하는 통화이기 때문에 출력할 때 100배를 증가시켜 출력한다.



*--------------------------------------------------------------------*
* 금액은 항상 P 타입으로 선언하면 되는가? ===> 아니다.
*--------------------------------------------------------------------*
* 금액은 P 타입이 아니라 금액 전용타입으로 선언해야 올바르다.
* 금액 전용타입이란, CURR 타입의 Domain을 사용하는 Data Element 를 의미한다.
*--------------------------------------------------------------------*

* 주로 사용되는 금액전용 타입으로 선언한 변수
DATA GV_AMOUNT_FOREIGN TYPE WRBTR. " 거래 통화 기준의 금액
DATA GV_AMOUNT_LOCAL TYPE DMBTR. " 현지 통화 기준의 금액

*--------------------------------------------------------------------*
* 금액은 항상 통화를 함께 사용해야만 한다.
*--------------------------------------------------------------------*

* 통화키를 지닌 상수
CONSTANTS GC_CURRENCY_KRW TYPE WAERS VALUE 'KRW'. " 원화는 소수점을 사용하지 않는다.
CONSTANTS GC_CURRENCY_USD TYPE WAERS VALUE 'USD'. " 엔화는 소수점을 사용하지 않는다.
CONSTANTS GC_CURRENCY_EUR TYPE WAERS VALUE 'EUR'. " 유로는 소수점 2자리를 사용한다.
CONSTANTS GC_CURRENCY_JPY TYPE WAERS VALUE 'JPY'. " 달러는 소수점 2자리를 사용한다.


* 금액 출력 예시를 위해 변수 선언
DATA: GV_PRICE_KRW TYPE SFLIGHT-PRICE,
      GV_PRICE_USD TYPE SFLIGHT-PRICE,
      GV_PRICE_EUR TYPE SFLIGHT-PRICE,
      GV_PRICE_JPY TYPE SFLIGHT-PRICE.

" 4개의 변수에 모두 숫자 1000 을 기록
GV_PRICE_KRW = GV_PRICE_USD = GV_PRICE_EUR = GV_PRICE_JPY = 1000.

ULINE.
WRITE : / '통화코드 없이 금액 출력(SAP 표준 금액계산 로직 미작동)'.
ULINE.
WRITE : / 'KRW = ', GV_PRICE_KRW.
WRITE : / 'JPY = ', GV_PRICE_JPY.
WRITE : / 'USD = ', GV_PRICE_USD.
WRITE : / 'EUR = ', GV_PRICE_EUR.
ULINE.

SKIP.

ULINE.
WRITE : / '통화코드 함께 금액 출력(SAP 표준 금액계산 로직 작동)'.
ULINE.
WRITE : / 'KRW = ', GV_PRICE_KRW CURRENCY GC_CURRENCY_KRW, '(원화는 소수점을 사용하지 않는다.)'.
WRITE : / 'JPY = ', GV_PRICE_JPY CURRENCY GC_CURRENCY_JPY, '(엔화는 소수점을 사용하지 않는다.)'.
WRITE : / 'USD = ', GV_PRICE_USD CURRENCY GC_CURRENCY_USD, '(유로는 소수점 2자리를 사용한다.)'.
WRITE : / 'EUR = ', GV_PRICE_EUR CURRENCY GC_CURRENCY_EUR, '(달러는 소수점 2자리를 사용한다.)'.
ULINE.
