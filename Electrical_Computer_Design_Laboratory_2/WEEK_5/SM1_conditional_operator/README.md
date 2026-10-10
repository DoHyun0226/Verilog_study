# SM1_conditional_operator

상태 머신 SM1을 **if-else if + 조건 연산자**로 구현한 버전입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `SM1_conditional_operator.srcs/sources_1/new/SM_1_conditional_operator.v` | 설계 (`SM_1_conditional_operator`) |

## 상태도

| 현재 상태 | x = 0 → (다음 상태, y) | x = 1 → (다음 상태, y) |
|---|---|---|
| 00 | 00, 0 | 01, 0 |
| 01 | 00, 1 | 11, 0 |
| 10 | 00, 1 | 10, 0 |
| 11 | 00, 1 | 10, 0 |

`y`도 클럭에 맞춰 레지스터에 저장됩니다. 같은 상태도를 네 가지 코딩 방식으로 구현한 프로젝트가 [SM1](../SM1), [SM1_case](../SM1_case), [SM1_case_sep](../SM1_case_sep), [SM1_conditional_operator](../SM1_conditional_operator)입니다.

## 참고

이 버전은 상태 00에서 `x = 1`일 때 `{state, y} <= 3'bxxx`로 되어 있어 위 표(01, 0)와 다릅니다. 시뮬레이션에서는 `state`가 `x`(unknown)가 됩니다.
