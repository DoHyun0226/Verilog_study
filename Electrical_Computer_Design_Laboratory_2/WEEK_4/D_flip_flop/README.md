# D_flip_flop

비동기 active-low 리셋이 있는 D 플립플롭입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `D_flip_flop.srcs/sources_1/new/DFF.v` | 설계 (`DFF`) |
| `D_flip_flop.srcs/sim_1/new/t_DFF.v` | 테스트벤치 |
| `D_flip_flop.srcs/constrs_1/new/D_flip_flop.xdc` | 핀 제약 |

## 동작

- `rst = 0` → `Q = 0` (클럭과 무관)
- 그 외에는 `clk` 상승 에지마다 `Q <= D`
