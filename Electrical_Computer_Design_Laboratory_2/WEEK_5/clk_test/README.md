# clk_test

보드 진단용 예제입니다. 메인 클럭(B6)이 FPGA에 실제로 들어오는지 확인합니다. Vivado 프로젝트 없이 Tcl 스크립트로 빌드합니다.

## 파일

| 파일 | 내용 |
|---|---|
| `clk_test.v` | 설계 (`clk_test`) |
| `clk_test.xdc` | 핀 제약 |
| `build.tcl` | 비프로젝트 모드 빌드 스크립트 (합성 → 배치·배선 → `clk_test.bit`) |
| `clockInfo.txt` | Vivado가 생성한 클럭 라우팅 정보 |

## LED 의미

| LED | 신호 | 확인 내용 |
|---|---|---|
| LED1 | 항상 1 | FPGA 구성과 LED가 정상인지 |
| LED2 | `rst` (DIP 스위치 1) | 입력 핀이 정상인지 (클럭 무관) |
| LED3 | `btn` (버튼 SM_1) | 버튼이 정상인지 (클럭 무관) |
| LED4 | `cnt[25]` | 클럭이 들어오면 깜빡임 |

## 빌드

Vivado Tcl 셸에서 이 폴더로 이동한 뒤 실행합니다.

```
vivado -mode batch -source build.tcl
```
