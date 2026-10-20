# example1_LED_control

DIP 스위치 8개로 받은 기준값 `bin`(0 ~ 255)에 따라 **단색 LED 밝기를 PWM으로 제어**하고, `bin`을 **7-segment 어레이**에 10진수로 표시합니다 (예: `00000173`). 결과 보고서 5.1, 5.2용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `example1_LED_control.srcs/sources_1/new/LED_control.v` | 최상위 (`LED_control`), 비교기 |
| `example1_LED_control.srcs/sources_1/new/counter8.v` | 8비트 업카운터 (`counter8`) |
| `example1_LED_control.srcs/sources_1/new/seg7_controller.v` | 7-segment 어레이 제어 (`seg7_controller`), 백의 자리까지 표시 |
| `example1_LED_control.srcs/sources_1/new/bin2bcd.v` | 8비트 2진수 → 3자리 BCD 변환, excess-3 방식 (`bin2bcd`) |
| `example1_LED_control.srcs/sim_1/new/t_LED_control.v` | 테스트벤치 (`t_LED_control`, 예비 보고서 4.4) |
| `example1_LED_control.srcs/constrs_1/new/LED_control.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-high 리셋 (누르면 1) | 버튼 SM_1 |
| `bin[7:0]` | 기준값 | DIP 스위치 SW1 ~ SW8 (`bin[7]`이 SW1, MSB) |
| `led_signal` | PWM 출력 | LED1 |
| `seg_data[7:0]` | `{a, b, c, d, e, f, g, dp}` (active-high) | 어레이 AR_SEG_A ~ AR_SEG_DP |
| `seg_sel[7:0]` | 자리 선택 (active-low) | 어레이 AR_SEG_S7 ~ AR_SEG_S0 (`seg_sel[0]`이 맨 오른쪽 S7) |

## 동작

```
             +-----------+  cnt   +------------+
  clk, rst ->| counter8  |------->|            |
             +-----------+        | comparator |--> led_signal (PWM)
  bin -------+------------------->|            |
             |                    +------------+
             |  +-----------------+
             +->| seg7_controller |--> seg_data, seg_sel
                +-----------------+
```

1. `counter8`이 클럭마다 `cnt`를 1씩 올립니다. 255 다음에는 overflow로 0이 됩니다.
2. 비교기가 `cnt <= bin`일 때 `led_signal = 1`로 둡니다. 256클럭 중 (bin + 1)클럭 동안 켜지므로 duty = (bin + 1) / 256입니다. `led_signal`은 레지스터라서 `cnt`보다 1클럭 늦게 바뀝니다 (duty는 같음).
3. `bin2bcd`가 excess-3(double dabble) 방식으로 `bin`을 `{백, 십, 일}` BCD로 바꿉니다. 클럭마다 한 단계씩 처리해 8클럭에 한 번 결과(`bcd_out`)가 갱신됩니다.
4. `seg7_controller`가 `seg_sel`을 클럭마다 회전시키며 8자리를 차례로 켭니다 (다이내믹 구동). 오른쪽부터 일·십·백의 자리, 나머지 5자리는 0을 표시합니다.

| bin | ON / 주기 | duty |
|---|---|---|
| 0 | 1 / 256 | 약 0.4 % (완전히 꺼지지 않음) |
| 63 | 64 / 256 | 25 % |
| 127 | 128 / 256 | 50 % |
| 191 | 192 / 256 | 75 % |
| 255 | 256 / 256 | 100 % |

## 시뮬레이션

- `t_LED_control`: 1 MHz 클럭(1클럭 = 1 µs, PWM 주기 256 µs)에서 `bin`을 0, 63, 127, 191, 255로 768 µs(3주기)씩 바꿉니다.
- 값마다 256 µs 뒤 한 주기 동안 `led_signal`을 샘플링해 ON/OFF 시간과 duty를 Tcl 콘솔에 `$display`로 출력하고, (bin + 1) / 256과 비교해 PASS/FAIL을 표시합니다.
- 프로젝트의 시뮬레이션 실행 시간이 4000 µs로 설정되어 있습니다 (`$finish`는 약 3842 µs).
- 결과: 5개 값 모두 PASS.

## 참고

- `seg_sel`이 클럭마다 바뀌므로 50 MHz에서는 7-segment 표시가 깨질 수 있습니다 (WEEK_6 example3과 같은 현상). LED 밝기 제어는 50 MHz에서도 정상입니다. 표시가 이상하면 메인 클럭을 낮추세요.
- 결과 보고서 5.2(클럭 10 Hz): 코드에 분주기가 없으므로 보드의 메인 클럭 설정을 바꿉니다. PWM 주기가 25.6 s가 되어 ON 시간 = (bin + 1) × 0.1 s를 직접 잴 수 있습니다. 7-segment는 자리마다 0.1 s씩 켜지며 도는 것이 보입니다.
