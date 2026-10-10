# and_or_xor_nor_nand

2비트 입력 `x`에 대해 AND / OR / XOR / NOR / NAND를 **축약(reduction) 연산자**(`&x`, `|x`, `^x`, `~|x`, `~&x`)로 구현합니다.

## 파일

| 파일 | 내용 |
|---|---|
| `and_or_xor_nor_nand.srcs/sources_1/new/AOXNN.v` | 설계 (`AOXNN`) |
| `and_or_xor_nor_nand.srcs/sim_1/new/t_AOXNN.v` | 테스트벤치 |
| `and_or_xor_nor_nand.srcs/constrs_1/new/AOXNN.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `x[1:0]` | 입력 | DIP 스위치 1, 2 |
| `and_o`, `or_o`, `xor_o`, `nor_o`, `nand_o` | 각 게이트 출력 | LED1 ~ LED5 |
