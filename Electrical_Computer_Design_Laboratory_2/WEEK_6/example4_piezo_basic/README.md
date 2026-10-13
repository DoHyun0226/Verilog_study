# example4_piezo_basic

버튼 8개로 피에조 부저에서 도 ~ 높은 도(약 261 ~ 523 Hz)를 냅니다.

## 파일

| 파일 | 내용 |
|---|---|
| `example4_piezo_basic.srcs/sources_1/new/piezo_basic.v` | 설계 (`piezo_basic`) |
| `example4_piezo_basic.srcs/sim_1/new/t_piezo_basic_1.v` | 테스트벤치 (`t_piezo_basic_1`, 시뮬레이션 최상위) |
| `example4_piezo_basic.srcs/sim_1/new/t_piezo_basic.v` | 이전 테스트벤치 (`t_piezo_basic`, Vivado 프로젝트에서 disable 상태) |
| `example4_piezo_basic.srcs/constrs_1/new/piezo_basic.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 1 MHz 클럭 | B6 (메인 클럭) |
| `rst` | active-low 리셋 | DIP 스위치 1 |
| `btn[7:0]` | 도 ~ 높은 도 | 버튼 SM_1 ~ SM_8 (`btn[0]`이 SM_1) |
| `piezo` | 구형파 출력 | 피에조 (Y21) |

## 동작

- 기준 클럭은 **1 MHz**입니다.
- 음 parameter(`C2` ~ `C3`)는 그 음의 **한 주기 클럭 수**입니다. 주파수 = 1 MHz / 값

| parameter | 값 | 주파수 | 음 |
|---|---|---|---|
| C2 | 3830 | ~261.1 Hz | 도 (C4) |
| D2 | 3400 | ~294.1 Hz | 레 (D4) |
| E2 | 3038 | ~329.2 Hz | 미 (E4) |
| F2 | 2864 | ~349.2 Hz | 파 (F4) |
| G2 | 2550 | ~392.2 Hz | 솔 (G4) |
| A2 | 2272 | ~440.1 Hz | 라 (A4) |
| B2 | 2028 | ~493.1 Hz | 시 (B4) |
| C3 | 1912 | ~523.0 Hz | 높은 도 (C5) |

1. if-else if 사슬이 눌린 버튼에 해당하는 값을 `cnt_limit`에 넣습니다. 여러 버튼을 동시에 누르면 **번호가 작은 버튼**이 우선하고, 아무것도 안 누르면 0입니다.
2. `cnt`가 `cnt_limit/2`에 도달할 때마다 `piezo`를 반전합니다. 그래서 주기가 `cnt_limit`인 50% 듀티 구형파가 나옵니다.

## 시뮬레이션

두 테스트벤치 모두 `` `timescale 1us / 1ns ``에서 `#0.5`마다 클럭을 반전해 1 MHz를 만듭니다.

### t_piezo_basic_1 (현재 시뮬레이션 최상위)

- 도 ~ 높은 도 버튼을 차례로 20 ms씩 누릅니다 (가장 낮은 도도 5주기 이상 보임).
- 음마다 `piezo`의 2번째 상승 에지에서 주기와 주파수를 `$display`로 출력합니다 (첫 상승 에지까지는 이전 음과 섞여 있으므로 건너뜀).
- `$finish`가 약 160 ms에 있어 기본 실행 시간보다 길므로 `run all`로 실행합니다.

### t_piezo_basic (disable 상태)

- 시나리오: t = 1 s 리셋 → 2 s 리셋 해제 → 3 s `btn[0]` (도) → 4 s `btn[1]` (레)
- Tcl 콘솔에서 `run 5 s` 이상으로 실행합니다. `$finish`가 없어서 `run all`은 끝나지 않습니다.

## 참고

- `cnt`가 0부터 `cnt_limit/2`까지 세므로, 실제 반주기는 1클럭 길어서 (주기는 parameter + 2클럭) 음이 아주 조금 낮습니다. 예: 도 3832 µs (260.96 Hz), 라 2274 µs (439.75 Hz)
- `cnt_limit = 0`(버튼 없음)이면 `piezo`가 클럭마다 토글됩니다 (500 kHz, 들리지 않음).
