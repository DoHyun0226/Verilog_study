# 5_1_pre_report

예비 보고서용 시뮬레이션입니다. **blocking 대입(`=`)**의 동작을 확인합니다. 짝인 [5_2_pre_report](../5_2_pre_report)는 같은 코드를 non-blocking으로 바꾼 버전입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `5_1_pre_report.srcs/sim_1/new/pre_report_5_1.v` | 시뮬레이션 모듈 (`pre_report_5_1`) |
| `pre_report_5_1_behav.wcfg` | 파형 창 설정 |

## 동작

초기값 `A = 4, B = 9, C = 14, D = 19`에서 t = 10에 아래 세 줄을 실행합니다.

```verilog
B = A + C; C = A + B; A = B + C;
```

blocking 대입은 위에서부터 차례로 바로 반영되므로, 앞 줄에서 바뀐 값을 다음 줄이 사용합니다.
→ `B = 18`, `C = 22`, `A = 40`
