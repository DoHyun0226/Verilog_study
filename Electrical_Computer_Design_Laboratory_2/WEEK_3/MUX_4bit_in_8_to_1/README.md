# MUX_4bit_in_8_to_1

4비트 데이터 8개(32비트 버스 `in`) 중 하나를 3비트 `sel`로 고르는 8:1 MUX입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `MUX_4bit_in_8_to_1.srcs/sources_1/new/MUX_4bit_in_8_to_1.v` | 설계 (`MUX_4bit_in_8_to_1`) |
| `MUX_4bit_in_8_to_1.srcs/sim_1/new/t_MUX_4bit_in_8_to_1.v` | 테스트벤치 |

## 입출력

| 포트 | 의미 |
|---|---|
| `in[31:0]` | 데이터 8개, `in[4k+3:4k]`가 k번째 데이터 |
| `sel[2:0]` | 선택 신호 |
| `out[3:0]` | 선택된 데이터 |

제약 파일은 없습니다 (시뮬레이션 전용).
