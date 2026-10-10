# NO1_logic_gate

2입력 AND / OR / XOR 게이트를 `assign`문으로 구현한 첫 실습입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `NO1_logic_gate.srcs/sources_1/new/logic_gate.v` | 설계 (`logic_gate`) |
| `NO1_logic_gate.srcs/constrs_1/new/logic_gate.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `a`, `b` | 입력 | DIP 스위치 1, 2 (Y1, W3) |
| `x` | `a & b` | LED1 (L4) |
| `y` | `a \| b` | LED2 (M4) |
| `z` | `a ^ b` | LED3 (M2) |
