# counter_3bit

버튼을 누를 때마다 1씩 증가하거나 감소하는 3비트 업/다운 카운터입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `counter_3bit.srcs/sources_1/new/counter_3bit.v` | 설계 (`counter_3bit`) |
| `counter_3bit.srcs/sim_1/new/t_counter_3bit.v` | 테스트벤치 |
| `counter_3bit.srcs/constrs_1/new/counter_3bit.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-low 리셋 | DIP 스위치 1 |
| `x` | 방향 (1: up, 0: down) | DIP 스위치 2 |
| `btn` | 카운트 버튼 (one-shot 적용) | 버튼 SM_1 |
| `state[2:0]` | 현재 값 | LED1 ~ LED3 |
