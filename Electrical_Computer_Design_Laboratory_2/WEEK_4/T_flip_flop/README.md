# T_flip_flop

비동기 active-low 리셋이 있는 T 플립플롭입니다. **one-shot trigger를 적용하지 않은** 버전입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `T_flip_flop.srcs/sources_1/new/TFF.v` | 설계 (`TFF`) |
| `T_flip_flop.srcs/sim_1/new/t_TFF.v` | 테스트벤치 |
| `T_flip_flop.srcs/constrs_1/new/T_flip_flop.xdc` | 핀 제약 |

## 동작

- `rst = 0` → `Q = 0`
- `T = 1`인 동안 `clk` 상승 에지마다 `Q`가 반전됩니다.

`T`를 버튼으로 누르고 있으면 클럭마다 계속 반전되기 때문에, 한 번 누를 때 한 번만 반전시키려면 one-shot trigger가 필요합니다 → [T_flip_flop_one_shot_trigger](../T_flip_flop_one_shot_trigger).
