# LCD_cursur_final_3

[LCD_cursur_final_2](../LCD_cursur_final_2)(SW2로 줄 전환)에 더해, 화면에 보이는 마지막 칸에서 `#`를 누르면 커서가 같은 줄 0번 칸으로 돌아오게 했습니다. 결과 보고서 C용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `LCD_cursur_final_3.srcs/sources_1/new/LCD_cursur.v` | LCD 커서 제어 상태 머신 (`LCD_cursur`) |
| `LCD_cursur_final_3.srcs/sources_1/new/oneshot_universal.v` | 버튼·스위치 원샷 트리거 (`WIDTH = 14`) |
| `LCD_cursur_final_3.srcs/sim_1/new/t_LCD_cursur.v` | 테스트벤치 (결과 보고서 C) |
| `LCD_cursur_final_3.srcs/constrs_1/new/LCD_cursur.xdc` | 핀 제약 (final_2와 같음) |

## final_2에서 바꾼 점

16 × 2 LCD에 보이는 칸은 줄마다 0x00 ~ 0x0F, 0x40 ~ 0x4F이지만, DD-RAM은 줄마다 40칸(0x00 ~ 0x27, 0x40 ~ 0x67)입니다. 그래서 각 줄의 보이는 마지막 칸인 0x0F나 0x4F에서 오른쪽으로 옮기면 커서가 화면 밖(internal 영역)으로 들어갑니다.

- `DISP_LAST_COL = 15` 파라미터 추가
- CURSOR에서 `#`일 때 `col >= DISP_LAST_COL`이면 커서 오른쪽 이동(`0x14`) 대신 **주소 설정 `{1, dip, 000000}`** 을 냅니다 (0x0F → 0x00, 0x4F → 0x40).
  `>=`로 비교하므로 숫자를 써서 커서가 이미 화면 밖으로 나간 경우에도 `#`로 돌아옵니다.
- `col`이 주소 설정 명령(`LCD_DATA[7] = 1`)도 따라가도록 `col <= LCD_DATA[5:0]` 추가

## 시뮬레이션

`t_LCD_cursur`: 1 kHz 클럭, 초기화 뒤 `#`를 40 ms씩 누르고 10 ms씩 쉬며 입력합니다.

| 입력 | LCD 출력 | 의미 |
|---|---|---|
| LINE1에서 `#` × 15 | RS = 0, `0001_0100` | 열 0 → 15 (0x0F) |
| 16번째 `#` | RS = 0, `1000_0000` | 주소 0x00 (0x10이 아님) |
| SW2 = 1 | RS = 0, `1100_0000` | 주소 0x40 (LINE2, 0열) |
| LINE2에서 `#` × 15 | RS = 0, `0001_0100` | 열 0 → 15 (0x4F) |
| 16번째 `#` | RS = 0, `1100_0000` | 주소 0x40 (0x50이 아님) |

파형에는 `U1/state`, `U1/cnt`, `U1/col`, `dip`, `LED_out`, `LCD_RS`, `LCD_RW`, `LCD_DATA`를 넣으면 됩니다. 의미 있는 LCD 출력은 Tcl 콘솔에도 출력됩니다.
