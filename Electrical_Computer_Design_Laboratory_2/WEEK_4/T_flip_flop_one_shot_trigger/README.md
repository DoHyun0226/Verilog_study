# T_flip_flop_one_shot_trigger

**one-shot trigger**를 적용한 T 플립플롭입니다. `T`가 0 → 1로 바뀌는 순간에만 `Q`가 한 번 반전됩니다.

## 파일

| 파일 | 내용 |
|---|---|
| `T_flip_flop_one_shot_trigger.srcs/sources_1/new/TFF_oneshot.v` | 설계 (`TFF_oneshot`) |
| `T_flip_flop_one_shot_trigger.srcs/sim_1/new/t_TFF_oneshot.v` | 테스트벤치 |
| `T_flip_flop_one_shot_trigger.srcs/constrs_1/new/T_flip_flop_one_shot_trigger.xdc` | 핀 제약 |

## 동작

```verilog
T_reg  <= T;            // 이전 클럭의 T
T_trig <= T & ~T_reg;   // 상승 에지에서만 1클럭 동안 1
if (T_trig) Q <= ~Q;
```

## 보드 연결

| 포트 | 핀 |
|---|---|
| `T` | Y1 (DIP 스위치 1) |
| `clk` | K4 (버튼) |
| `rst` | N8 |
| `Q` | L4 (LED1) |

`clk`를 일반 I/O 핀(K4, 버튼)에 연결했기 때문에 `CLOCK_DEDICATED_ROUTE FALSE` 제약을 추가했습니다. 보드의 실제 클럭을 쓰는 버전은 [T_flip_flop_one_shot_trigger_real clock](<../T_flip_flop_one_shot_trigger_real clock>)입니다.
