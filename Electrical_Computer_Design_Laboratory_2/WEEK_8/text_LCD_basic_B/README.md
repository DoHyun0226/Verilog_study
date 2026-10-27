# text_LCD_basic_B

LINE2 상태 코드는 그대로 두고 **LCD를 한 줄만 쓰도록** Function Set 명령어를 바꾼 버전입니다. 결과 보고서 C (예비 보고서 B)용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `text_LCD_basic_B.srcs/sources_1/new/text_LCD_basic_B.v` | LCD 제어 상태 머신 (`text_LCD_basic`) |
| `text_LCD_basic_B.srcs/constrs_1/new/text_LCD_basic_B.xdc` | 핀 제약 |

보드 연결은 [WEEK_8 README](../README.md#보드-연결-네-프로젝트-공통)와 같습니다.

## text_LCD_basic과 다른 점

| 항목 | text_LCD_basic | text_LCD_basic_B |
|---|---|---|
| Function Set | `0x38` (`N = 1`, 2줄) | `0x30` (`N = 0`, 1줄) |
| `LINE1_CNT`, `LINE2_CNT` | 20 | 16 |

### Function Set N = 0

`DB = 0 0 1 DL N F x x`에서 N을 0으로 바꾸면 1-line 모드가 됩니다. DD-RAM 0x00 ~ 0x4F가 한 줄(80칸)이 되고 화면에는 윗줄 0x00 ~ 0x0F만 표시되며, 아랫줄은 비어 있습니다.

### LINE 한계값 16

1-line 모드에서 0x40은 2번째 줄이 아니라 같은 줄의 64번째 칸입니다. 그리고 주소 카운터가 0x4F 다음 0x00으로 돌아갑니다. 교안 값(20)대로 0x40부터 20글자를 쓰면 마지막 4글자(공백)가 0x00 ~ 0x03에 써져서, 매 루프 끝에 윗줄 앞부분 `" HEL"`이 공백으로 덮입니다.

```
" HELLO WORLD!   " -> "  ELLO WORLD!   " -> "   LLO WORLD!   " -> "    LO WORLD!   "
```

그래서 LINE1, LINE2를 cnt 16(주소 설정 1 + 16글자)에서 끝내 각 줄의 마지막 칸(0x0F, 0x4F)까지만 씁니다. 한 루프는 46클럭(17 + 17 + 6 + 6)입니다.

## 화면

```
+----------------+
| HELLO WORLD!   |   0x00 ~ 0x0F
|                |   (0x40 ~ 0x4F의 학번은 화면 밖)
+----------------+
```

## 시뮬레이션

LCD 모델 테스트벤치(1-line 모드, 0x4F → 0x00 wrap, 저장소 미포함)로 확인했습니다.

- Function Set이 1-line(`N = 0`)으로 설정됨
- LINE2의 문자 쓰기 16번이 모두 0x40 ~ 0x4F에 들어가고, 0x00 ~ 0x0F에 쓴 횟수는 0
- 매 루프 끝 윗줄: `" HELLO WORLD!   "`
