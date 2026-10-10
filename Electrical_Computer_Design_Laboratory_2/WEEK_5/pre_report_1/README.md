# pre_report_1

예비 보고서 1: 2비트 상태를 가진 **Mealy 머신**입니다. 상태 전이는 SM1과 같고, 출력은 조합 논리로 바로 나옵니다.

## 파일

| 파일 | 내용 |
|---|---|
| `pre_report_1.srcs/sources_1/new/pre_report_1.v` | 설계 (`pre_report_1`) |
| `pre_report_1.srcs/sim_1/new/t_pre_report_1.v` | 테스트벤치 |
| `pre_report_1.srcs/constrs_1/new/pre_report_1.xdc` | 핀 제약 |

## 동작

- 상태 전이: `in = 0`이면 00으로 돌아가고, `in = 1`이면 00 → 01 → 11 → 10 → 10 …
- 출력: `out = (state != 00) & ~in` (Mealy 출력, 레지스터 없음)
