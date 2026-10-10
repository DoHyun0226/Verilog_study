# 5_2_pre_report

예비 보고서용 시뮬레이션입니다. **non-blocking 대입(`<=`)**의 동작을 확인합니다. 짝인 [5_1_pre_report](../5_1_pre_report)는 blocking 버전입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `5_2_pre_report.srcs/sim_1/new/pre_report_5_2.v` | 시뮬레이션 모듈 (`pre_report_5_2`) |

## 동작

초기값 `A = 4, B = 9, C = 14, D = 19`에서 t = 10에 아래 세 줄을 실행합니다.

```verilog
B <= A + C; C <= A + B; A <= B + C;
```

non-blocking 대입은 우변을 모두 **이전 값**으로 계산한 뒤 한꺼번에 반영합니다.
→ `B = 18`, `C = 13`, `A = 23`
