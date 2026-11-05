# WEEK_9 — Text LCD 커서 제어

숫자 버튼으로 커서 위치에 0 ~ 9를 쓰고, `*` / `#` 버튼으로 커서를 왼쪽 / 오른쪽으로 옮기는 예제입니다. 세 프로젝트 모두 모듈 이름이 `LCD_cursur`이고, 앞 프로젝트에 기능을 하나씩 더했습니다.

| 프로젝트 | 내용 | 보고서 |
|---|---|---|
| [LCD_cursur](LCD_cursur) | 숫자 버튼으로 쓰기, `*` / `#`로 커서 이동 (교안 예제) | 예비 보고서 A, 결과 보고서 A |
| [LCD_cursur_final_2](LCD_cursur_final_2) | + DIP 스위치 SW2로 커서를 LINE1 / LINE2로 전환 (같은 열 유지) | 결과 보고서 B |
| [LCD_cursur_final_3](LCD_cursur_final_3) | + 보이는 마지막 칸(0x0F, 0x4F)에서 `#`를 누르면 그 줄 0번 칸(0x00, 0x40)으로 | 결과 보고서 C |

## 제어 방식

WEEK_8과 같이 `LCD_E = clk`라서 **클럭 1번 = LCD 쓰기 1번**이고, 상태 머신이 상태마다 명령어나 문자를 내보냅니다. 초기화가 끝나면 DELAY_T에서 버튼을 기다립니다.

```
DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE -> SET_ADDRESS   (리셋 후 한 번)
      -> DELAY_T -> WRITE       -> DELAY_T ...   (숫자 버튼)
      -> DELAY_T -> CURSOR      -> DELAY_T ...   (* 또는 #)
      -> DELAY_T -> LINE_CHANGE -> DELAY_T ...   (SW2 변경, final_2 / final_3만)
```

| 상태 | 머무는 클럭 | 출력 |
|---|---|---|
| DELAY | 71 | LCD 전원 리셋 대기 (≥ 50 ms) |
| FUNCTION_SET | 31 | `0x38` (8비트, 2줄, 5×8) |
| DISP_ONOFF | 31 | `0x0F` (화면 ON, 커서 ON, 깜빡임 ON) |
| ENTRY_MODE | 31 | `0x06` (쓸 때마다 주소 +1) |
| SET_ADDRESS | 101 | 예제: `0x02` Return Home / final_2·3: SW2에 맞는 줄의 0번 칸 주소 설정 |
| DELAY_T | 버튼까지 | `0x0F` (아무것도 바꾸지 않는 명령) |
| WRITE | 31 | cnt 20에서 누른 숫자의 ASCII (`0x30` ~ `0x39`, RS = 1) |
| CURSOR | 31 | cnt 20에서 `*` → `0x10` (왼쪽), `#` → `0x14` (오른쪽) |
| LINE_CHANGE | 31 | cnt 20에서 주소 설정 `{1, SW2, col}` (final_2·3) |

- 버튼은 `oneshot_universal`을 거쳐 DELAY_T를 한 번만 빠져나가게 합니다. 실제 출력은 cnt 20에서 버튼 값을 다시 보고 정하므로, **버튼을 20클럭(1 kHz에서 20 ms) 이상 눌러야** 써집니다.
- `LED_out`은 현재 상태를 one-hot으로 보여 줍니다 (LED8 = DELAY ... LED3 = DELAY_T, LED2 = WRITE, LED1 = CURSOR, LED2 + LED1 = LINE_CHANGE).

## 보드 연결 (세 프로젝트 공통)

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭, `LCD_E`로도 그대로 출력 | B6 (메인 클럭, 약 1 kHz로 낮춰서 사용) |
| `rst` | active-low 리셋 (0 = 리셋) | DIP 스위치 SW1 |
| `dip` | 커서 줄, 0 = LINE1, 1 = LINE2 (final_2·3만) | DIP 스위치 SW2 |
| `number_btn[9:0]` | `[9]` = 1 ... `[1]` = 9, `[0]` = 0 | SM_1 ~ SM_9 (K4, N8, N4, N1, P6, N6, L5, J2, K2), SM_11 (L1) |
| `control_btn[1:0]` | `[1]` = `*` (왼쪽), `[0]` = `#` (오른쪽) | SM_10 (L7), SM_12 (K6) |
| `LCD_E`, `LCD_RS`, `LCD_RW` | LCD 제어 | A6, G6, D6 |
| `LCD_DATA[7:0]` | DB7 ~ DB0 (`LCD_DATA[0]` = LCD_D0) | A4, B2, C3, D4, A2, C5, C1, D1 (D0 ~ D7) |
| `LED_out[7:0]` | 현재 상태 | LED8 (`LED_out[7]`) ~ LED1 (`LED_out[0]`) |

## 참고

- WEEK_8과 같이 제약 파일에 `create_clock`이 없어서 TIMING-17 경고가 뜹니다. 느린 클럭용 설계라 그대로 두었습니다.
- 스위치(SW2)는 DELAY_T에서만 봅니다. WRITE / CURSOR / LINE_CHANGE 도중(31 ms)에 바꾸면 다음 변경 때까지 반영되지 않습니다.
