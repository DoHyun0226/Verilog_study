# 4_bit_comparator

4비트 크기 비교기입니다. 관계 연산자와 조건 연산자(`? :`)로 구현했습니다.

## 파일

| 파일 | 내용 |
|---|---|
| `4_bit_comparator.srcs/sources_1/new/comparator_4bit.v` | 설계 (`comparator_4bit`) |
| `4_bit_comparator.srcs/sim_1/new/t_comparator_4bit.v` | 테스트벤치 |
| `4_bit_comparator.srcs/constrs_1/new/comparator_4bit.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `a[3:0]` | 입력 A | DIP 스위치 1 ~ 4 |
| `b[3:0]` | 입력 B | DIP 스위치 5 ~ 8 |
| `x` | `a > b` | LED1 |
| `y` | `a == b` | LED2 |
| `z` | `a < b` | LED3 |
