# text_LCD_basic

Text LCD 윗줄에 `HELLO WORLD!`, 아랫줄에 학번 + 이니셜(`2023440075 YDH`)을 표시하는 교안 예제입니다. 결과 보고서 A, B용이며, 예비 보고서 A(state 변화 시뮬레이션)도 이 프로젝트입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `text_LCD_basic.srcs/sources_1/new/text_LCD_basic.v` | LCD 제어 상태 머신 (`text_LCD_basic`) |
| `text_LCD_basic.srcs/sim_1/new/t_text_LCD_basic.v` | 테스트벤치 (`t_text_LCD_basic`, 예비 보고서 A) |
| `text_LCD_basic.srcs/constrs_1/new/text_LCD_basic.xdc` | 핀 제약 |
| `t_text_LCD_basic_behav.wcfg` | 파형 설정 |

교안 코드에서 바꾼 점:

1. 클럭 always 블록을 non-blocking(`<=`) 대입으로 작성
2. cnt 블록의 `default : state = DELAY;` → `default : cnt <= 0;` (state는 한 always 블록에서만 대입)
3. 상태마다의 cnt 한계값을 `*_CNT` 파라미터로 분리 (값은 교안과 같음)

보드 연결은 [WEEK_8 README](../README.md#보드-연결-네-프로젝트-공통)와 같습니다.

## 화면

```
 0x00               0x0F
+----------------+
| HELLO WORLD!   |   LINE1: 0x00부터 20글자 (0x10 ~ 0x13은 공백, 화면 밖)
|2023440075 YDH  |   LINE2: 0x40부터 20글자 (0x50 ~ 0x53은 공백, 화면 밖)
+----------------+
 0x40               0x4F
```

한 루프(54클럭)마다 LINE1 → LINE2로 글자를 쓰고, DELAY_T(Return Home) → CLEAR_DISP(Clear Display)로 화면을 지운 뒤 다시 씁니다.

## 시뮬레이션

- `t_text_LCD_basic`: 1 kHz 클럭(1클럭 = 1 ms), 리셋 1.8 ms, 300 ms에서 종료. state가 바뀔 때마다 Tcl 콘솔에 시각과 state를 출력합니다.

| 시각 | state |
|---|---|
| 0 ms | DELAY (000) |
| 72.5 ms | FUNCTION_SET (001) |
| 103.5 ms | DISP_ONOFF (011) |
| 134.5 ms | ENTRY_MODE (010) |
| 165.5 ms | LINE1 (100) |
| 186.5 ms | LINE2 (101) |
| 207.5 ms | DELAY_T (110) |
| 213.5 ms | CLEAR_DISP (111) |
| 219.5 ms | LINE1 (100), 이후 54 ms마다 반복 |

- LCD 모델 테스트벤치(저장소 미포함)로 확인한 화면: 윗줄 `" HELLO WORLD!   "`, 아랫줄 `"2023440075 YDH  "`.

## 결과 보고서 B (클럭 1 Hz)

비트스트림은 그대로 두고 보드의 메인 클럭만 1 Hz로 바꿉니다. 1초에 LCD 쓰기 1번이므로

- LINE1: 1초 동안 주소 설정(0x80), 이후 1초에 한 글자씩 윗줄에 써집니다.
- LINE2: 주소 설정(0xC0) 뒤 아랫줄에 한 글자씩 써집니다.
- DELAY_T(6초), CLEAR_DISP(6초) 뒤 화면이 지워지고 다시 씁니다.
- `LED_out`으로 현재 상태를 볼 수 있습니다 (LED4 = LINE1, LED3 = LINE2).

LCD는 주소 카운터 위치에 한 글자씩 받아 저장하고, 쓸 때마다 주소가 자동으로 1 증가하는 방식이라는 것을 눈으로 확인할 수 있습니다.
