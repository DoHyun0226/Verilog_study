# LCD_cursur_final_2

[LCD_cursur](../LCD_cursur) 예제에 DIP 스위치 SW2로 커서를 LINE1 / LINE2로 옮기는 기능을 더했습니다. 결과 보고서 B용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `LCD_cursur_final_2.srcs/sources_1/new/LCD_cursur.v` | LCD 커서 제어 상태 머신 (`LCD_cursur`) |
| `LCD_cursur_final_2.srcs/sources_1/new/oneshot_universal.v` | 버튼·스위치 원샷 트리거 (`WIDTH = 14`) |
| `LCD_cursur_final_2.srcs/sim_1/new/t_LCD_cursur.v` | 테스트벤치 (결과 보고서 B) |
| `LCD_cursur_final_2.srcs/constrs_1/new/LCD_cursur.xdc` | 핀 제약 (+ `dip` = SW2, W3) |

## 예제에서 바꾼 점

1. 입력 `dip` 추가: 0 = LINE1, 1 = LINE2
2. 원샷에 `{dip, ~dip}` 추가: 원샷은 상승 에지만 잡으므로, `~dip`으로 1 → 0(LINE1로 복귀)도 잡습니다.
3. 상태 LINE_CHANGE 추가: 3비트 상태가 모두 쓰여서 `state`를 4비트로 늘렸습니다.
4. `col` 레지스터로 커서 열(0 ~ 39)을 기억: LINE1은 0x00 ~, LINE2는 0x40 ~ 이라 주소 비트 A6만 다르므로, 줄을 바꿔도 같은 열에 커서가 갑니다.
5. SET_ADDRESS에서 Return Home 대신 SW2에 맞는 줄의 0번 칸으로 주소를 설정: 스위치가 이미 LINE2에 있으면 처음부터 LINE2에서 시작합니다.

LINE_CHANGE는 cnt 20에서 주소 설정 명령 `{1, dip, col}`을 냅니다 (예: LINE2, 1열 → `1100_0001` = 0x41).

`col`은 LCD에 실제로 나간 명령을 따라갑니다. 문자를 쓰거나 오른쪽 이동이면 +1(39 다음 0), 왼쪽 이동이면 −1(0 다음 39)입니다. 그래서 cnt 20 전에 버튼을 떼서 아무것도 쓰지 않은 경우에는 움직이지 않습니다.

## 시뮬레이션

`t_LCD_cursur`: 1 kHz 클럭, 초기화 뒤 200 ms 간격으로 입력합니다. 1.4 s에서 종료합니다.

| 입력 | LCD 출력 | 의미 |
|---|---|---|
| 버튼 1 | RS = 1, `0011_0001` | 0x00에 `'1'`, 열 0 → 1 |
| SW2 = 1 | RS = 0, `1100_0001` | 주소 0x41 (LINE2, 같은 열) |
| 버튼 2 | RS = 1, `0011_0010` | 0x41에 `'2'`, 열 1 → 2 |
| `*` | RS = 0, `0001_0000` | 열 2 → 1 |
| SW2 = 0 | RS = 0, `1000_0001` | 주소 0x01 (LINE1, 같은 열) |

파형에는 `U1/state`, `U1/cnt`, `U1/col`, `dip`, `LED_out`, `LCD_RS`, `LCD_RW`, `LCD_DATA`를 넣으면 됩니다.
