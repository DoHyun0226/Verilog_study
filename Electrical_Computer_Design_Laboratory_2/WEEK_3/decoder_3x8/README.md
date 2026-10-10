# decoder_3x8

3×8 디코더입니다. `case(x)`로 입력 값에 해당하는 출력 비트 하나만 1로 만듭니다 (active-high).

## 파일

| 파일 | 내용 |
|---|---|
| `decoder_3x8.srcs/sources_1/new/decoder_3x8.v` | 설계 (`decoder_3x8`) |
| `decoder_3x8.srcs/sim_1/new/t_decoder_3x8.v` | 테스트벤치 |
| `decoder_3x8.srcs/constrs_1/new/decoder_3x8.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `x[2:0]` | 입력 | DIP 스위치 1 ~ 3 |
| `D[7:0]` | 디코더 출력 | LED1 ~ LED8 |
