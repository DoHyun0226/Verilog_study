# dac_7_segment_text_LCD

예비 보고서 D의 DAC 예제에 **DAC 디지털 입력을 7-segment와 Text LCD로 확인하는 기능**을 더한 프로젝트입니다. 시뮬레이션 없이 코드만 제출하는 과제라 테스트벤치는 없습니다.

## 파일

| 파일 | 내용 |
|---|---|
| `DAC_display.v` | 최상위 모듈 (`DAC_display`), 아래 세 모듈 연결 |
| `DAC.v` | DAC 제어 상태 머신, [DAC](../DAC) 프로젝트와 같음 |
| `oneshot_universal.v` | 버튼 원샷 트리거, [DAC](../DAC) 프로젝트와 같음 |
| `seg7_controller.v`, `bin2bcd.v` | 7-segment 어레이에 0 ~ 255를 10진수로 표시, WEEK_7 `example1_LED_control`과 같음 |
| `LCD_display.v` | Text LCD에 값을 10진수 / 16진수 / 2진수로 표시 (새로 작성) |
| `DAC_display.xdc` | 핀 제약 |

(소스는 `dac_7_segment_text_LCD.srcs/sources_1/new`, 제약은 `constrs_1/new`에 있고 프로젝트에 추가되어 있습니다. top = `DAC_display`)

## 구조

```
          +-----+  dac_d, dac_wrn, dac_a_b ...  --> AD7302
btn ----->| DAC |  led_out (dac_d_temp)        --> LED8 ~ LED1
add_sel ->|     |
          +-----+
             | dac_d, dac_a_b
             +--> seg7_controller --> 7-segment  "00000173"
             +--> LCD_display     --> Text LCD   "DEC:173  HEX:AD "
                                                 "BIN:10101101 [A]"
```

- 7-segment와 LCD는 **`dac_d`(실제로 AD7302 D7 ~ D0 핀에 나가는 값)** 를 보여 줍니다. 버튼을 누르면 LED(`dac_d_temp`)는 바로 바뀌고, 7-segment·LCD는 다음 UP_DATA 상태(최대 283클럭 뒤)에 바뀝니다.
- `seg7_controller`, `bin2bcd`는 active-high 리셋이라 `~rst`를 넣었습니다.

## 표시 내용

값이 173(= 0xAD = 1010_1101), 출력 A일 때:

| 장치 | 표시 |
|---|---|
| 7-segment | `00000173` (오른쪽 세 자리가 백·십·일의 자리) |
| LCD 1번째 줄 | `DEC:173  HEX:AD ` |
| LCD 2번째 줄 | `BIN:10101101 [A]` (`[A]` = VOUTA, `[B]` = VOUTB, `dac_a_b` 값) |
| LED8 ~ LED1 | `dac_d_temp` (리셋 중 `0101_0101`) |

## LCD_display 동작

WEEK_8 `text_LCD_basic`과 같은 방식(`LCD_E = clk`, 클럭 1번 = LCD 쓰기 1번)입니다.

```
DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE   (리셋 후 한 번)
      -> LINE1 -> LINE2 -> LINE1 -> LINE2 ...        (반복)
```

| 상태 | 머무는 클럭 | 출력 |
|---|---|---|
| DELAY | 71 | 없음 (RW = 1), LCD 전원 리셋 대기 |
| FUNCTION_SET | 31 | `0x38` (8비트, 2줄, 5×8) |
| DISP_ONOFF | 31 | `0x0C` (화면 ON, 커서 OFF) |
| ENTRY_MODE | 31 | `0x06` (쓸 때마다 주소 +1) |
| LINE1 | 17 | cnt 0: 주소 `0x80`, cnt 1 ~ 16: `DEC:xxx  HEX:xx ` |
| LINE2 | 17 | cnt 0: 주소 `0xC0`, cnt 1 ~ 16: `BIN:xxxxxxxx [x]` |

- 매 루프(34클럭)마다 16칸을 전부 다시 쓰므로 Clear Display 없이도 값이 바뀌면 화면이 따라 바뀝니다 (깜빡임 없음).
- 숫자는 ASCII로 바꿔서 씁니다: 10진수 자리·2진수 비트는 `0x30 + 값`, 16진수 A ~ F는 `0x37 + 값` (`0x37 + 10 = 0x41 = 'A'`).
- 10진수 자리는 `LCD_display` 안의 `bin2bcd`로 구합니다.

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 (LCD_E로도 출력) | B6 (메인 클럭, **약 1 kHz로 낮춰서 사용**) |
| `rst` | active-low 리셋 (0 = 리셋) | DIP 스위치 SW1 |
| `add_sel` | 출력 선택, 0 = VOUTA, 1 = VOUTB | DIP 스위치 SW2 |
| `btn[5:0]` | SM_1 −1, SM_3 +1, SM_4 −2, SM_6 +2, SM_7 −8, SM_9 +8 | K4, N4, N1, N6, L5, K2 |
| `dac_d[7:0]`, `dac_a_b`, `dac_csn`, `dac_ldacn`, `dac_wrn` | AD7302 | [DAC](../DAC)와 같음 |
| `led_out[7:0]` | `dac_d_temp` | LED8 ~ LED1 |
| `seg_data[7:0]` | 7-segment {a, b, c, d, e, f, g, dp} | F1, F5, E2, E4, J1, J3, J7, H2 |
| `seg_sel[7:0]` | 자리 선택 (active low), `[0]` = 맨 오른쪽 | K5, K3, K1, L6, G3, G1, H6, H4 |
| `LCD_E`, `LCD_RS`, `LCD_RW` | LCD 제어 | A6, G6, D6 |
| `LCD_DATA[7:0]` | LCD_D0 ~ LCD_D7 | A4, B2, C3, D4, A2, C5, C1, D1 |

## 클럭

분주기 없이 클럭 하나로 세 장치를 모두 돌리므로, LCD에 맞춰 **메인 클럭을 약 1 kHz로** 낮춥니다.

| 장치 | 1 kHz에서 |
|---|---|
| Text LCD | 클럭 1번 = 쓰기 1번, 화면 전체 갱신 34 ms |
| 7-segment | 클럭마다 한 자리씩, 8자리 → 자리마다 125 Hz로 갱신 (깜빡임 없음) |
| DAC | 283클럭 = 283 ms마다 한 번 쓰기 |

50 MHz 그대로면 LCD가 동작하지 않고 7-segment도 너무 빨라 제대로 안 보입니다.

## 참고

- Vivado에서 합성·배치까지 에러 없이 되는 것을 확인했습니다. `DAC.v`(교안 코드) 때문에 경고 두 개(`dac_ldacn_reg` 제거, `dac_d_reg` Set/Reset)가 뜨는데, DAC 프로젝트와 같고 동작에는 영향이 없습니다.
- 제약 파일에 `create_clock`이 없어서 TIMING-17 경고가 뜹니다. 다른 주차와 같이 그대로 두었습니다.
