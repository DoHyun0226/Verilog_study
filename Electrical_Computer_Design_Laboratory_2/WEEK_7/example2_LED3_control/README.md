# example2_LED3_control

버튼 8개로 **3색(RGB) LED 4개**의 색을 무지개색과 백색으로 바꿉니다. R, G, B마다 PWM을 따로 만들어 밝기를 조절하고, 세 빛이 섞여 원하는 색이 보입니다. 결과 보고서 5.3, 5.4용입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `example2_LED3_control.srcs/sources_1/new/LED3_control.v` | 최상위 (`LED3_control`), 색 선택과 비교기 3개 |
| `example2_LED3_control.srcs/sources_1/new/counter8.v` | 8비트 업카운터 (`counter8`), example1과 같음 |
| `example2_LED3_control.srcs/sim_1/new/t_LED3_control.v` | 테스트벤치 (`t_LED3_control`, 예비 보고서 4.5) |
| `example2_LED3_control.srcs/constrs_1/new/LED3_control.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-high 리셋 (누르면 1, LED 꺼짐) | 버튼 SM_9 |
| `btn[7:0]` | 색 선택 | 버튼 SM_1 ~ SM_8 (`btn[0]`이 SM_1) |
| `led_signal_R[3:0]` | 빨강 PWM | CLED_R1 ~ CLED_R4 |
| `led_signal_G[3:0]` | 초록 PWM | CLED_G1 ~ CLED_G4 |
| `led_signal_B[3:0]` | 파랑 PWM | CLED_B1 ~ CLED_B4 |

SM_1 ~ SM_8을 색 선택에 쓰므로 리셋은 SM_9에 연결했습니다.

## 동작

| 버튼 | 색 | {R, G, B} |
|---|---|---|
| SM_1 | 빨강 | {255, 0, 0} |
| SM_2 | 주황 | {255, 102, 0} |
| SM_3 | 노랑 | {255, 255, 0} |
| SM_4 | 초록 | {0, 255, 0} |
| SM_5 | 파랑 | {0, 0, 255} |
| SM_6 | 남색 | {0, 0, 128} |
| SM_7 | 보라 | {128, 0, 128} |
| SM_8 | 흰색 | {255, 255, 255} |

1. if-else if 사슬이 눌린 버튼의 색을 24비트 `state = {R, G, B}`에 넣습니다. 여러 버튼을 동시에 누르면 **번호가 작은 버튼**이 우선하고, 아무것도 안 누르면 마지막 색을 유지합니다. 같은 색을 계속 넣을 뿐이라 one-shot은 필요 없습니다.
2. 비교기 3개가 `cnt < state[23:16]`(R), `cnt < state[15:8]`(G), `cnt < state[7:0]`(B)일 때 해당 출력을 `4'b1111`로 둡니다. duty = 기준값 / 256입니다.
3. 보드의 RGB LED 4개는 모두 같은 값으로 구동합니다.

## 시뮬레이션

- `t_LED3_control`: 1 MHz 클럭에서 SM_1(빨강), SM_2(주황), SM_3(노랑)을 10 µs씩 누르고, 색마다 768 µs(3주기) 동안 관찰합니다.
- 색마다 256 µs 뒤 한 주기 동안 R, G, B의 ON/OFF 시간을 Tcl 콘솔에 `$display`로 출력하고, `state`의 기준값과 비교해 PASS/FAIL을 표시합니다.
- 파형에는 `U1/state`(기준값)와 `led_signal_R/G/B`를 추가해서 봅니다.
- 프로젝트의 시뮬레이션 실행 시간이 2400 µs로 설정되어 있습니다 (`$finish`는 약 2336 µs).
- 결과: 빨강, 주황, 노랑 모두 PASS (주황: R 255 µs, G 102 µs, B 0 µs ON / 256 µs).

## 참고

- 결과 보고서 5.4(주황, 10 Hz ~ 1 MHz): 코드에 분주기가 없으므로 보드의 메인 클럭 설정을 바꿉니다. 클럭이 낮으면 PWM 주기가 길어 R과 G가 따로 켜지고 꺼지는 것이 보이고(10 Hz에서 주기 25.6 s), 클럭이 높아지면 깜빡임이 사라지며 두 빛이 섞여 주황색으로 보입니다.
- 기준값 255도 256클럭 중 1클럭은 꺼지므로 100 %가 아니라 약 99.6 %입니다.
