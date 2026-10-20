# Electrical_Computer_Design_Laboratory_2

전기전자컴퓨터설계실험 2 주차별 Verilog 실습입니다. 모두 Xilinx Vivado 프로젝트이며, 보드 FPGA는 Spartan-7 `xc7s75fgga484-1`입니다.

| 주차 | 내용 |
|---|---|
| [WEEK_2](WEEK_2) | 기본 논리 게이트, 반가산기, 전가산기 |
| [WEEK_3](WEEK_3) | 비교기, MUX, 디코더, 우선순위 인코더 |
| [WEEK_4](WEEK_4) | SR 래치, D/JK/T 플립플롭, one-shot trigger, blocking/non-blocking |
| [WEEK_5](WEEK_5) | 상태 머신(SM1, 자판기 SM2), 카운터, 보드·클럭 테스트 |
| [WEEK_6](WEEK_6) | 7-segment 표시(단일, 어레이), 피에조 부저 |
| [WEEK_7](WEEK_7) | LED PWM 제어(단색 LED 밝기, 3색 LED 색상) |

각 프로젝트 폴더의 README에 파일 구성, 입출력, 보드 핀 연결을 정리했습니다.

## 보드 핀 (제약 파일에서 자주 쓰는 것)

| 핀 | 보드 |
|---|---|
| B6 | 메인 클럭 |
| Y1, W3, U2, T1, W4, W1, V4, U4 | DIP 스위치 SW1 ~ SW8 |
| K4, N8, N4, N1, P6, N6, L5, J2, K2 | 버튼 SM_1 ~ SM_9 |
| L4, M4, M2, N7 | LED1 ~ LED4 |
| P1, P3, P7, N3, T5, R2, R4, R6 | 7-segment SEG_A ~ SEG_G, SEG_DP |
| F1, F5, E2, E4, J1, J3, J7, H2 | 7-segment 어레이 AR_SEG_A ~ AR_SEG_G, AR_SEG_DP |
| H4, H6, G1, G3, L6, K1, K3, K5 | 7-segment 어레이 자리 선택 AR_SEG_S0 (왼쪽) ~ AR_SEG_S7 (오른쪽) |
| Y21 | 피에조 부저 |
| T2, U1, P2, R3 | 3색 LED 빨강 CLED_R1 ~ CLED_R4 |
| U5, V1, R7, T6 | 3색 LED 초록 CLED_G1 ~ CLED_G4 |
| U3, W2, R5, T3 | 3색 LED 파랑 CLED_B1 ~ CLED_B4 |
