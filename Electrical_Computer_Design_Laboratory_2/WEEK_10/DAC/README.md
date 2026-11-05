# DAC

AD7302 8비트 DAC 제어 교안 예제입니다. 버튼으로 DAC 입력값(`dac_d_temp`)을 바꾸면 상태 머신이 주기적으로 그 값을 DAC에 씁니다. 예비 보고서 D(버튼별 state·DAC 입력 변화 시뮬레이션)와 결과 보고서 A, B용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `DAC.srcs/sources_1/new/DAC.v` | DAC 제어 상태 머신 (`DAC`) |
| `DAC.srcs/sources_1/new/oneshot_universal.v` | 버튼 원샷 트리거 (WEEK_9와 같은 모듈, `WIDTH = 6`) |
| `DAC.srcs/sim_1/new/t_DAC.v` | 테스트벤치 (`t_DAC`, 예비 보고서 D) |
| `DAC.srcs/constrs_1/new/DAC.xdc` | 핀 제약 |

코드는 교안과 같고 주석만 붙였습니다.

## 동작

```
DELAY (201클럭) -> SET_WRN (51클럭) -> UP_DATA (31클럭) -> DELAY ...   (한 번 쓰기 = 283클럭)
```

| 상태 | `dac_wrn` | 하는 일 |
|---|---|---|
| DELAY | 1 | WR을 1로 올림 → 이 상승 에지에서 DAC가 `dac_d`를 받아 감 |
| SET_WRN | 0 | WR을 0으로 내림 |
| UP_DATA | 0 (유지) | `dac_d <= dac_d_temp` |

`dac_d`가 UP_DATA에서 바뀐 뒤 31클럭 동안 그대로 있다가 WR이 올라가므로, DAC는 항상 안정된 값을 받습니다. 버튼으로 바꾼 값은 다음 UP_DATA에서 `dac_d`로 나가고, 그다음 DELAY 진입 시 DAC 출력에 반영됩니다.

| 버튼 | `btn` 비트 | `dac_d_temp` |
|---|---|---|
| SM_1 | `btn[5]` | −1 |
| SM_3 | `btn[4]` | +1 |
| SM_4 | `btn[3]` | −2 |
| SM_6 | `btn[2]` | +2 |
| SM_7 | `btn[1]` | −8 |
| SM_9 | `btn[0]` | +8 |

- 버튼은 `oneshot_universal`을 거쳐 누를 때 1클럭 펄스(`btn_t`)가 됩니다. 버튼을 오래 눌러도 한 번만 바뀝니다.
- 8비트라서 0에서 −1이면 255, 255에서 +1이면 0으로 넘어갑니다.
- `led_out`은 리셋 시 `0101_0101`, 이후에는 `dac_d_temp`(1클럭 늦게)를 LED로 보여 줍니다.

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-low 리셋 (0 = 리셋) | DIP 스위치 SW1 |
| `add_sel` | 출력 선택, 0 = VOUTA, 1 = VOUTB | DIP 스위치 SW2 |
| `btn[5:0]` | SM_1, SM_3, SM_4, SM_6, SM_7, SM_9 | K4, N4, N1, N6, L5, K2 |
| `dac_d[7:0]` | DAC_D7 (MSB) ~ DAC_D0 | B3, B1, C4, C2, D5, D2, E5, E3 |
| `dac_a_b` | DAC_A_B | G2 |
| `dac_csn` | DAC_CSN | E1 |
| `dac_ldacn` | DAC_LDACN | F4 |
| `dac_wrn` | DAC_WRN | G4 |
| `led_out[7:0]` | DAC 입력값 | LED8 (`led_out[7]`, MSB) ~ LED1 (`led_out[0]`) |

- VOUTA(DAC_OUT_A)는 보드에 내장된 전압계에 연결되어 있어 LED로 출력 전압을 볼 수 있습니다.
- VOUTB(DAC_OUT_B)는 DAC_OUT 핀에 연결되어 있어 오실로스코프로 전압을 측정합니다 (결과 보고서 B).

## 시뮬레이션

`t_DAC`: 50 MHz 클럭(1클럭 = 20 ns, 한 번 쓰기 = 5.66 µs), 리셋 100 ns. 버튼을 1 µs씩 누르고 10 µs씩 기다려서 값마다 DAC 쓰기가 한 번 이상 일어나게 했습니다. 버튼 펄스마다 `dac_d_temp`를, WR 상승 에지에서 새로 래치된 `dac_d`를 Tcl 콘솔에 출력합니다.

| 버튼 | `btn_t` | `dac_d_temp` | WR 상승 (래치) |
|---|---|---|---|
| (리셋 후) | | 0 | 5.77 µs, `dac_d` = 0 |
| SM_9 +8 | `000001` | 8 | 11.43 µs, 8 |
| SM_6 +2 | `000100` | 10 | 22.75 µs, 10 |
| SM_3 +1 | `010000` | 11 | 34.07 µs, 11 |
| SM_1 −1 | `100000` | 10 | 45.39 µs, 10 |
| SM_4 −2 | `001000` | 8 | 56.71 µs, 8 |
| SM_7 −8 | `000010` | 0 | 68.03 µs, 0 |
| SM_1 −1 | `100000` | 255 (wrap) | 79.35 µs, 255 |
| SM_3 +1 | `010000` | 0 (wrap) | 90.67 µs, 0 |

마지막에 `add_sel = 1`로 바꿔 `dac_a_b`가 1(VOUTB)로 바뀌는 것도 볼 수 있습니다. 파형에는 `btn`, `U1/btn_t`, `U1/state`, `U1/cnt`, `U1/dac_d_temp`, `dac_wrn`, `dac_d`, `dac_a_b`, `led_out`을 넣으면 됩니다.

## 클럭 변경 시 참고

- 분주기가 없어서 한 번 쓰기가 283클럭입니다. 50 MHz면 5.66 µs, 1 kHz면 283 ms마다 DAC 값이 갱신됩니다.
- 원샷은 버튼 채터링을 거르지 않습니다. 50 MHz처럼 빠른 클럭에서는 한 번 눌러도 값이 여러 번 바뀔 수 있으니, 그럴 때는 WEEK_8, WEEK_9처럼 보드에서 메인 클럭을 낮춰서 씁니다.
- 제약 파일에 `create_clock`이 없어서 구현 후 TIMING-17 경고가 뜹니다. 다른 주차와 같이 그대로 두었습니다.
