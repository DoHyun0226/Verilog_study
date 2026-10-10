# JK_flip_flop

`case({J, K})`로 구현한 JK 플립플롭입니다. 리셋은 없습니다.

## 파일

| 파일 | 내용 |
|---|---|
| `JK_flip_flop.srcs/sources_1/new/JKFF.v` | 설계 (`JKFF`) |
| `JK_flip_flop.srcs/sim_1/new/t_JKFF.v` | 테스트벤치 |
| `JK_flip_flop.srcs/constrs_1/new/JK_flip_flop.xdc` | 핀 제약 |

## 동작 (`Clk` 상승 에지)

| J | K | Q |
|---|---|---|
| 0 | 0 | 유지 |
| 0 | 1 | 0 (reset) |
| 1 | 0 | 1 (set) |
| 1 | 1 | 반전 (toggle) |

`Q_b`는 항상 `~Q`입니다.
