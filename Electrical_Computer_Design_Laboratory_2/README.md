# Electrical_Computer_Design_Laboratory_2

전기전자컴퓨터설계실험 2 주차별 Verilog 실습입니다. 모두 Xilinx Vivado 프로젝트이며, 보드 FPGA는 Spartan-7 `xc7s75fgga484-1`입니다.

| 주차 | 내용 |
|---|---|
| [WEEK_2](WEEK_2) | 기본 논리 게이트, 반가산기, 전가산기 |
| [WEEK_3](WEEK_3) | 비교기, MUX, 디코더, 우선순위 인코더 |
| [WEEK_4](WEEK_4) | SR 래치, D/JK/T 플립플롭, one-shot trigger, blocking/non-blocking |
| [WEEK_5](WEEK_5) | 상태 머신(SM1, 자판기 SM2), 카운터, 보드·클럭 테스트 |
| [WEEK_6](WEEK_6) | 7-segment 표시 |

각 프로젝트 폴더의 README에 파일 구성, 입출력, 보드 핀 연결을 정리했습니다.

## 보드 핀 (제약 파일에서 자주 쓰는 것)

| 핀 | 보드 |
|---|---|
| B6 | 메인 클럭 |
| Y1, W3 | DIP 스위치 1, 2 |
| K4, N8, N4 | 버튼 SM_1, SM_2, SM_3 |
| L4, M4, M2, N7 | LED1 ~ LED4 |
