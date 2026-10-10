# SM2_conditional_operator

자판기 상태 머신 SM2를 **조건 연산자(`? :`) 중첩**으로 구현한 버전입니다. 상태 전이는 [SM_2](../SM_2)와 같습니다.

## 파일

| 파일 | 내용 |
|---|---|
| `SM2_conditional_operator.srcs/sources_1/new/SM2_conditional_operator.v` | 설계 (`SM2_conditional_operator`) |
| `SM2_conditional_operator.srcs/sources_1/new/SM2_conditional_operator_modified.v` | 수정 버전: 구매 시 `y`를 5초 유지 |
| `SM2_conditional_operator.srcs/sources_1/new/SM2_one_shot.v` | 3비트 one-shot trigger |
| `SM2_conditional_operator.srcs/sim_1/new/t_SM2_conditional_operator.v` | 테스트벤치 |
| `SM2_conditional_operator.srcs/sim_1/new/t_SM2_conditional_operator_20ns_period.v` | 테스트벤치 (클럭 주기 20 ns = 50 MHz) |
| `SM2_conditional_operator.srcs/constrs_1/new/SM2_conditional_operator.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-low 리셋 | DIP 스위치 1 |
| `A` | 50원 | 버튼 SM_1 |
| `B` | 100원 | 버튼 SM_2 |
| `C` | 구매 | 버튼 SM_3 |
| `state[2:0]` | 현재 금액 | LED1 ~ LED3 |
| `y` | 음료 출력 | LED4 |

## 두 버전의 차이

| | `SM2_conditional_operator` | `SM2_conditional_operator_modified` |
|---|---|---|
| `y` | `(state == S200) & C` — 버튼을 누르고 있는 동안만 1 | S200에서 `C_trig`가 들어오면 카운터로 `HOLD` 클럭(50 MHz 기준 5초) 동안 1 |
