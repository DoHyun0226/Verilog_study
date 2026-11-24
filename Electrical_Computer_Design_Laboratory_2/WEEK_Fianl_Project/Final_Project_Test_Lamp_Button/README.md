# Final_Project_Test_Lamp_Button — 신호등 모듈 램프 테스트

기말 프로젝트용 신호등 모듈의 램프 24개를 확인하는 보드 테스트입니다. 버튼 SM_1 ~ SM_8을 누르면 교안 스테이트 A ~ H 그림의 램프가 켜집니다. 원래 [Final_Project](../Final_Project) `main.v`의 TEST_LAMP_BTN 빌드였던 것을 따로 떼어 낸 프로젝트입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `Test_Lamp_Button.v` | 최상위 모듈. 스테이트 A ~ H 램프 패턴 표 `ST_A` ~ `ST_H`, 버튼 → 패턴 |
| `oneshot_trigger.v` | `oneshot_universal`: 버튼을 누를 때 1클럭 펄스 (Final_Project와 같은 파일) |
| `common.xdc` | 클럭, 리셋, 램프 24개 핀 (Final_Project `common.xdc`와 같은 파일) |
| `test_lamp_btn.xdc` | 버튼 SM_1 ~ SM_8 핀 |

(소스는 `Final_Project_Test_Lamp_Button.srcs/sources_1/new`, 제약은 `constrs_1/new`에 있고 모두 프로젝트에 추가되어 있습니다. top = `Test_Lamp_Button`)

`ST_A` ~ `ST_H` 표는 Final_Project `lamp_pattern.v`와 같습니다. 2026-11-17 보드에서 A ~ H가 교안 그림과 맞는 것을 확인했습니다. 한쪽을 고치면 다른 쪽도 같이 고칩니다. `common.xdc`도 두 프로젝트가 같은 내용이어야 합니다.

## 보드 조작

| 입력 | 보드 | 기능 |
|---|---|---|
| `rst` | DIP SW1 | OFF = 리셋 (램프 모두 꺼짐), ON = 동작 |
| `btn[0]` ~ `btn[7]` | SM_1 ~ SM_8 | 스테이트 A ~ H 표시. 안 누르거나 두 개를 같이 누르면 그대로 |
| `clk` | B6 | 보드 기본 50 MHz |

## 핀 맵

모든 핀은 `IOSTANDARD LVCMOS33`입니다. 클럭, 리셋, 램프 24개 핀은 Final_Project와 같습니다 ([Final_Project README 핀 맵](../Final_Project/README.md#핀-맵)).

### 버튼 (`test_lamp_btn.xdc`)

| 포트 | FPGA 핀 | 보드 | 기능 |
|---|---|---|---|
| `btn[0]` | K4 | SM_1 | 스테이트 A |
| `btn[1]` | N8 | SM_2 | 스테이트 B |
| `btn[2]` | N4 | SM_3 | 스테이트 C |
| `btn[3]` | N1 | SM_4 | 스테이트 D |
| `btn[4]` | P6 | SM_5 | 스테이트 E |
| `btn[5]` | N6 | SM_6 | 스테이트 F |
| `btn[6]` | L5 | SM_7 | 스테이트 G |
| `btn[7]` | J2 | SM_8 | 스테이트 H |
