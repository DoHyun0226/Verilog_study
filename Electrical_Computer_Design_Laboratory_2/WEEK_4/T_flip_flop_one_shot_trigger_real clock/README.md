# T_flip_flop_one_shot_trigger_real clock

[T_flip_flop_one_shot_trigger](../T_flip_flop_one_shot_trigger)와 같은 설계를 **보드의 실제 클럭**으로 구동하는 버전입니다. 소스(`TFF_oneshot.v`)는 동일하고 제약 파일만 다릅니다.

## 파일

| 파일 | 내용 |
|---|---|
| `T_flip_flop_one_shot_trigger.srcs/sources_1/new/TFF_oneshot.v` | 설계 (`TFF_oneshot`) |
| `T_flip_flop_one_shot_trigger.srcs/sim_1/new/t_TFF_oneshot.v` | 테스트벤치 |
| `T_flip_flop_one_shot_trigger.srcs/constrs_1/new/T_flip_flop_one_shot_trigger_real_clock.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 핀 |
|---|---|
| `T` | Y1 (DIP 스위치 1) |
| `clk` | B6 (메인 클럭) |
| `rst` | N8 |
| `Q` | L4 (LED1) |

## 참고

폴더 이름에 공백이 있지만 내부 Vivado 프로젝트 이름은 `T_flip_flop_one_shot_trigger`입니다.
