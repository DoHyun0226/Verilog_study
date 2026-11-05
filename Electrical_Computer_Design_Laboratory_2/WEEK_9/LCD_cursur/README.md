# LCD_cursur

숫자 버튼(SM_1 ~ SM_9, SM_11)으로 커서 위치에 숫자를 쓰고, `*`(SM_10) / `#`(SM_12)로 커서를 왼쪽 / 오른쪽으로 옮기는 교안 예제입니다. 예비 보고서 A(시뮬레이션)와 결과 보고서 A(학번 + 띄어쓰기 + 실험 날짜 입력)용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `LCD_cursur.srcs/sources_1/new/LCD_cursur.v` | LCD 커서 제어 상태 머신 (`LCD_cursur`) |
| `LCD_cursur.srcs/sources_1/new/oneshot_universal.v` | 버튼 원샷 트리거 (`WIDTH = 12`) |
| `LCD_cursur.srcs/sim_1/new/t_LCD_cursur.v` | 테스트벤치 (예비 보고서 A) |
| `LCD_cursur.srcs/constrs_1/new/LCD_cursur.xdc` | 핀 제약 |

교안 코드에서 바꾼 점:

1. 모듈 이름 `LCD_cursor` → `LCD_cursur` (프로젝트 이름과 같게)
2. DISP_ONOFF의 `LED_out` `8'b0010_0001` → `8'b0010_0000` (다른 상태처럼 one-hot)
3. 상태마다의 cnt 한계값을 `*_CNT` 파라미터로 분리 (값은 교안과 같음)

상태 흐름과 보드 연결은 [WEEK_9 README](../README.md)에 있습니다.

## 시뮬레이션 (예비 보고서 A)

`t_LCD_cursur`: 1 kHz 클럭(1클럭 = 1 ms), 초기화가 끝난 뒤 버튼을 100 ms씩 누르고 100 ms 간격으로 `9` → `5` → `*` → `#` 순서로 입력합니다. 1.2 s에서 종료합니다.

| 버튼 | state | LCD 출력 (cnt 20) |
|---|---|---|
| 9 | WRITE | RS = 1, `0011_1001` (`'9'`) |
| 5 | WRITE | RS = 1, `0011_0101` (`'5'`) |
| `*` | CURSOR | RS = 0, `0001_0000` (커서 왼쪽) |
| `#` | CURSOR | RS = 0, `0001_0100` (커서 오른쪽) |

파형에는 `U1/state`, `U1/cnt`, `LED_out`, `LCD_RS`, `LCD_RW`, `LCD_DATA`를 넣으면 됩니다. state가 바뀔 때와 LCD에 의미 있는 값이 나갈 때마다 Tcl 콘솔에도 출력됩니다.

## 결과 보고서 A

보드 클럭을 약 1 kHz로 낮추고, 숫자 버튼으로 학번을 입력한 뒤 `#`로 한 칸 띄우고 실험 날짜를 입력합니다 (예: `2023440075 1103`). 띄어쓰기는 문자를 쓰지 않고 커서만 오른쪽으로 옮기는 것이라, 리셋 직후처럼 빈 칸 위에서만 공백으로 보입니다.
