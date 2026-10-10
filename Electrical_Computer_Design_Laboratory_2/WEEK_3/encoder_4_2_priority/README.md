# encoder_4_2_priority

4:2 우선순위 인코더입니다. 높은 번호의 입력이 우선하며, 논리식으로 구현했습니다.

## 파일

| 파일 | 내용 |
|---|---|
| `encoder_4_2_priority.srcs/sources_1/new/encoder_4_2_priority.v` | 설계 (`encoder_4_2_priority`) |
| `encoder_4_2_priority.srcs/sim_1/new/t_encoder_4_2_priority.v` | 테스트벤치 |
| `encoder_4_2_priority.srcs/constrs_1/new/encoder_4_2_priority.xdc` | 핀 제약 |

## 입출력

| 포트 | 의미 | 보드 |
|---|---|---|
| `in[3:0]` | 입력 (`in[3]`이 최우선) | DIP 스위치 1 ~ 4 |
| `out[1:0]` | 가장 높은 1인 입력의 번호 | LED1, LED2 |
| `valid` | 입력 중 하나라도 1이면 1 | LED3 |
