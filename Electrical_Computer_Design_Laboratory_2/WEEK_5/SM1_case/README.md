# SM1_case

상태 머신 SM1을 **`case(state)` + 조건 연산자**로 구현한 버전입니다. 각 상태에서 `{state, y} <= x ? ... : ...` 형태로 대입합니다.

## 파일

| 파일 | 내용 |
|---|---|
| `SM1_case.srcs/sources_1/new/SM1_case.v` | 설계 (`SM1_case`) |

## 상태도

| 현재 상태 | x = 0 → (다음 상태, y) | x = 1 → (다음 상태, y) |
|---|---|---|
| 00 | 00, 0 | 01, 0 |
| 01 | 00, 1 | 11, 0 |
| 10 | 00, 1 | 10, 0 |
| 11 | 00, 1 | 10, 0 |

`y`도 클럭에 맞춰 레지스터에 저장됩니다. 같은 상태도를 네 가지 코딩 방식으로 구현한 프로젝트가 [SM1](../SM1), [SM1_case](../SM1_case), [SM1_case_sep](../SM1_case_sep), [SM1_conditional_operator](../SM1_conditional_operator)입니다.
