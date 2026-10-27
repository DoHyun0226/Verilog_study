# WEEK_8 — Text LCD

16 × 2 Text LCD에 문자를 표시하는 예제입니다. 네 프로젝트 모두 교안 예제 코드(`text_LCD_basic`)를 바탕으로 하며, 모듈 이름과 포트가 같고 결과 보고서 문제마다 필요한 부분만 바꿨습니다.

| 프로젝트 | 내용 | 결과 보고서 |
|---|---|---|
| [text_LCD_basic](text_LCD_basic) | 윗줄 `HELLO WORLD!`, 아랫줄 학번 + 이니셜 (교안 예제) | A, B (B는 보드 클럭만 1 Hz로) |
| [text_LCD_basic_B](text_LCD_basic_B) | Function Set `N = 0`으로 한 줄만 표시 | C (예비 보고서 B) |
| [text_LCD_basic_C](text_LCD_basic_C) | 시작 주소를 3칸 오른쪽(0x03, 0x43)으로 | D (예비 보고서 C) |
| [text_LCD_basic_D](text_LCD_basic_D) | 전광판처럼 루프마다 한 칸씩 왼쪽으로 shift | E (예비 보고서 D) |

## 제어 방식

상태 머신이 상태마다 LCD 명령어 또는 문자 하나를 클럭마다 출력하고, `LCD_E = clk`라서 LCD는 클럭의 하강 에지에서 그 값을 받아 갑니다. 즉 **클럭 1번 = LCD 쓰기 1번**입니다.

```
DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE         (리셋 후 한 번)
      -> LINE1 -> LINE2 -> DELAY_T -> CLEAR_DISP -> LINE1 ... (반복)
```

| 상태 | 머무는 클럭 | 출력 |
|---|---|---|
| DELAY | 71 | 없음 (RW = 1), LCD 전원 리셋 대기 (≥ 50 ms) |
| FUNCTION_SET | 31 | `0x38` (8비트, 2줄, 5×8) |
| DISP_ONOFF | 31 | `0x0C` (화면 ON, 커서 OFF) |
| ENTRY_MODE | 31 | `0x06` (쓸 때마다 주소 +1, 화면 shift 없음) |
| LINE1 | 21 | cnt 0: 주소 설정 `0x80` (0x00), cnt 1~20: 문자 |
| LINE2 | 21 | cnt 0: 주소 설정 `0xC0` (0x40), cnt 1~20: 문자 |
| DELAY_T | 6 | `0x02` Return Home |
| CLEAR_DISP | 6 | `0x01` Clear Display |

- 상태마다 머무는 시간은 `*_CNT` 파라미터(값 + 1클럭)로 정합니다. 교안 값 그대로이며 `text_LCD_basic_B`만 LINE1, LINE2를 16으로 줄였습니다.
- 출력은 레지스터라서 state / cnt보다 1클럭 늦게 나갑니다. 순서는 같습니다.
- 주석에서 `set addr`는 주소 설정 명령어(RS = 0), `addr`는 문자가 써지는 DD-RAM 주소(LCD 내부 주소 카운터가 정함), `ascii`는 DATA로 나가는 문자 코드(RS = 1)입니다.

## DD-RAM 주소

| 모드 | 1번째 줄 | 2번째 줄 | 화면에 보이는 칸 |
|---|---|---|---|
| 2-line (`N = 1`) | 0x00 ~ 0x27 (40칸) | 0x40 ~ 0x67 (40칸) | 0x00 ~ 0x0F, 0x40 ~ 0x4F |
| 1-line (`N = 0`) | 0x00 ~ 0x4F (80칸) | 없음 | 0x00 ~ 0x0F |

- 2-line 모드는 0x27 다음 0x40, 0x67 다음 0x00으로 넘어갑니다.
- 1-line 모드는 0x4F 다음 0x00으로 넘어갑니다. 그래서 1-line 모드에서 0x40부터 20칸을 쓰면 0x00 ~ 0x03(윗줄 앞부분)을 덮어씁니다 (`text_LCD_basic_B` 참고).

## 보드 연결 (네 프로젝트 공통)

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭, `LCD_E`로도 그대로 출력 | B6 (메인 클럭) |
| `rst` | active-low 리셋 (0 = 리셋) | DIP 스위치 SW1 |
| `LCD_E`, `LCD_RS`, `LCD_RW` | LCD 제어 | A6, G6, D6 |
| `LCD_DATA[7:0]` | DB7 ~ DB0 (`LCD_DATA[0]` = LCD_D0) | A4, B2, C3, D4, A2, C5, C1, D1 (D0 ~ D7) |
| `LED_out[7:0]` | 현재 상태 (one-hot) | LED8 ~ LED1 (`LED_out[7]` = LED8 = DELAY, `LED_out[0]` = LED1 = CLEAR_DISP) |

## 클럭

코드에 분주기가 없어서 클럭 1번에 LCD 쓰기 1번입니다. 메인 클럭(기본 50 MHz)은 LCD에 너무 빠르므로 **보드에서 메인 클럭을 낮춰서** 씁니다.

| 메인 클럭 | DELAY | 한 루프 (LINE1 ~ CLEAR_DISP, 54클럭) |
|---|---|---|
| 1 kHz | 71 ms | 54 ms |
| 1 Hz | 71 s | 54 s (결과 보고서 B: 글자가 한 개씩 써지는 것이 보임) |

1 kHz에서는 클럭 주기(1 ms)가 Clear Display / Return Home 실행 시간(약 1.52 ms)보다 짧지만, 같은 명령을 6클럭(6 ms) 동안 반복해서 내므로 정상 동작합니다. 나머지 명령어와 문자 쓰기는 약 37 ~ 43 µs라 1클럭이면 충분합니다.

## 참고

- 제약 파일에 `create_clock`이 없어서 구현 후 Methodology 경고(TIMING-17, 클럭이 정의되지 않은 FF)가 뜹니다. 느린 클럭에서 쓰는 설계라 동작에는 영향이 없어 그대로 두었습니다.
- 시뮬레이션은 `text_LCD_basic`의 테스트벤치(state 흐름)와, HD44780 동작(주소 증가·wrap, display shift)을 흉내 낸 LCD 모델 테스트벤치(저장소에는 포함하지 않음)로 화면 내용을 확인했습니다.
