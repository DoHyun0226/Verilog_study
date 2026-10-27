# text_LCD_basic_D

**LED 전광판처럼 글자가 한 칸씩 계속 왼쪽으로 흐르게** 만든 버전입니다. 결과 보고서 E (예비 보고서 D)용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `text_LCD_basic_D.srcs/sources_1/new/text_LCD_basic_D.v` | LCD 제어 상태 머신 (`text_LCD_basic`) |
| `text_LCD_basic_D.srcs/constrs_1/new/text_LCD_basic_D.xdc` | 핀 제약 |

보드 연결은 [WEEK_8 README](../README.md#보드-연결-네-프로젝트-공통)와 같습니다.

## text_LCD_basic과 다른 점

상태 전이(LINE1 → LINE2 → DELAY_T → CLEAR_DISP)는 그대로 두고 두 상태의 출력만 바꿨습니다.

| 상태 | text_LCD_basic | text_LCD_basic_D |
|---|---|---|
| DELAY_T | `0x02` Return Home | `0x0C` Display ON/OFF (설정값 그대로, 변화 없음) |
| CLEAR_DISP | `0x01` Clear Display | cnt 0: `0x18` Display Shift left (`S/C = 1`, `R/L = 0`), 나머지: `0x0C` |

- Clear Display는 DD-RAM을 지울 뿐 아니라 shift된 화면을 원래 위치로 되돌리고, Return Home도 DD-RAM은 그대로 두지만 shift를 되돌립니다. 그래서 둘 다 shift에 영향을 주지 않는 Display ON/OFF(0x0C)로 바꿨습니다.
- Display Shift는 DD-RAM과 주소 카운터는 그대로 두고 화면만 한 칸 옮깁니다. CLEAR_DISP는 6클럭 동안 머물므로 cnt 0일 때 한 번만 내야 루프마다 정확히 한 칸 움직입니다.
- LINE1, LINE2는 매 루프 같은 글자를 같은 주소에 다시 쓰지만, 주소 설정과 문자 쓰기는 shift 상태를 바꾸지 않으므로 화면은 계속 흐릅니다.

## 동작

2-line 모드에서는 두 줄이 함께 shift되고, 각 줄은 자기 40칸(0x00 ~ 0x27, 0x40 ~ 0x67) 안에서 순환합니다. 왼쪽으로 사라진 글자는 나머지 칸을 지나 오른쪽 끝에서 다시 들어오고, 40번 shift하면 처음 화면으로 돌아옵니다.

| 메인 클럭 | 한 칸 이동 (1루프, 54클럭) | 한 바퀴 (40칸) |
|---|---|---|
| 1 kHz | 54 ms | 약 2.16 s |

더 느리게 하려면 `DELAY_T_CNT`를 늘립니다.

## 시뮬레이션

Display Shift를 처리하는 LCD 모델 테스트벤치(저장소 미포함)로 43루프를 확인했습니다. Clear Display 0번, Return Home 0번, Display Shift 43번(루프마다 1번).

```
loop  0 | " HELLO WORLD!   " | "2023440075 YDH  "
loop  1 | "HELLO WORLD!    " | "023440075 YDH   "
loop  3 | "LLO WORLD!      " | "3440075 YDH     "
loop 16 | "                " | "                "
loop 32 | "         HELLO W" | "        20234400"
loop 39 | "  HELLO WORLD!  " | " 2023440075 YDH "
loop 40 | " HELLO WORLD!   " | "2023440075 YDH  "   <- 처음 화면
```

## 참고

Clear Display를 한 번도 보내지 않으므로, 한 번도 쓰지 않는 DD-RAM(0x14 ~ 0x27, 0x54 ~ 0x67)은 LCD 전원을 켤 때의 내용(내부 리셋으로 공백)이 그대로 남습니다. LCD 전원을 끄지 않고 FPGA만 다시 프로그래밍하면 이전 설계가 그 영역에 쓴 글자가 빈 구간에 보일 수 있으니, 그때는 LCD 전원을 껐다 켭니다.
