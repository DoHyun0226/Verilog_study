# full_adder

반가산기(`half_adder`) 2개와 OR 게이트로 전가산기를 구성한 구조적(structural) 설계입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `full_adder.srcs/sources_1/new/full_adder.v` | 최상위 (`full_adder`) |
| `full_adder.srcs/sources_1/new/half_adder.v` | 하위 모듈 (`half_adder`) |
| `full_adder.srcs/sim_1/new/t_full_adder.v` | 테스트벤치 |
| `full_adder.srcs/constrs_1/new/full_adder.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `x`, `y`, `c_in` | 피가산수, 가산수, 자리올림 입력 | DIP 스위치 1, 2, 3 |
| `s` | 합 | LED1 |
| `c_out` | 자리올림 출력 | LED2 |
