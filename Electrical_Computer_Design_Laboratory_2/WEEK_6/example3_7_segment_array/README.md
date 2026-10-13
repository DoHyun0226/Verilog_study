# example3_7_segment_array

버튼을 누를 때마다 0~15를 세고, 그 값을 **8자리 7-segment 어레이**의 오른쪽 두 자리에 10진수로 표시합니다 (예: `00000012`).

## 파일

| 파일 | 내용 |
|---|---|
| `example3_7_segment_array.srcs/sources_1/new/seg_array.v` | 최상위 (`seg_array`) |
| `example3_7_segment_array.srcs/sources_1/new/bin2bcd.v` | 4비트 2진수 → 2자리 BCD 변환 (`bin2bcd`) |
| `example3_7_segment_array.srcs/sources_1/new/one_shot_universal.v` | one-shot trigger. [example2](../example2_7_segment)에서 복사함 |
| `example3_7_segment_array.srcs/sim_1/new/t_seg_array.v` | 테스트벤치 (`t_seg_array`, 시뮬레이션 최상위) |
| `example3_7_segment_array.srcs/sim_1/new/t_bin2bcd.v` | `bin2bcd` 단독 테스트벤치 (Vivado 프로젝트에서 disable 상태) |
| `example3_7_segment_array.srcs/constrs_1/new/seg_array.xdc` | 핀 제약 |

## 보드 연결

| 포트 | 의미 | 보드 |
|---|---|---|
| `clk` | 클럭 | B6 (메인 클럭) |
| `rst` | active-low 리셋 | DIP 스위치 1 |
| `btn` | 카운트 버튼 | 버튼 SM_1 |
| `state_bin[3:0]` | 현재 값 (2진수) | LED1 ~ LED4 (`state_bin[3]`이 LED1) |
| `seg_data[7:0]` | `{a, b, c, d, e, f, g, dp}` | 어레이 AR_SEG_A ~ AR_SEG_DP |
| `seg_sel[7:0]` | 자리 선택 (active-low) | 어레이 AR_SEG_S7 ~ AR_SEG_S0 (`seg_sel[0]`이 맨 오른쪽 S7) |

## 동작

1. `one_shot_universal #(.WIDTH(1))`이 버튼의 상승 에지를 검출합니다.
2. `state_bin`이 버튼을 누를 때마다 1씩 증가합니다 (15 다음에는 0).
3. `bin2bcd`가 `state_bin`을 BCD로 바꿉니다. `state_bcd = {십의 자리, 일의 자리}`, 예: 12 → `{4'b0001, 4'b0010}`. `bin2bcd`는 클럭에 맞춰 출력하는 레지스터라서 1클럭 늦게 바뀝니다.
4. `seg_sel`이 클럭마다 왼쪽으로 회전하며 8자리를 차례로 선택합니다 (active-low, `8'b11111110`부터 시작). 이 방식을 **다이내믹 구동**이라고 합니다.
5. 자리 선택 블록(조합회로)이 선택된 자리에 맞는 숫자를 `bcd`에 넣습니다. 0번째 자리는 일의 자리, 1번째 자리는 십의 자리, 나머지는 0입니다.
6. 디코더(조합회로)가 `bcd`를 7-segment 패턴 `seg_data = {a, b, c, d, e, f, g, dp}` (active-high)로 바꿉니다.

5번과 6번은 `always @(*)` 조합회로입니다. 그래서 `seg_sel`이 바뀐 같은 클럭 안에 `seg_data`도 따라 바뀌고, 자리와 숫자가 어긋나지 않습니다.

## 시뮬레이션

- `t_seg_array`: 10 ns 주기 클럭에서 버튼을 80 ns(8클럭)마다 눌러, 값마다 `seg_sel` 8자리 스캔이 한 바퀴씩 보이게 합니다. 0 → 15 → 0 순환, 버튼을 80 ns 동안 누르고 있어도 한 번만 증가하는지, 비동기 리셋 뒤 다시 세는지를 확인합니다.
  - 버튼 → `btn_trig` → `state_bin` → `state_bcd`까지 3클럭이 걸립니다.
  - `$finish`가 약 1.6 µs에 있어 기본 실행 시간(1000 ns)보다 길므로 `run all`로 실행합니다.
  - 테스트벤치는 `seg_array`를 포트 5개로만 연결하므로 `state_bin` 출력은 연결되지 않습니다.
- `t_bin2bcd`: `bin`을 0 ~ 15로 바꾸며 `bcd`를 확인합니다. `$finish`가 없어서 `run all`은 끝나지 않습니다.

## 참고

- 사용하지 않는 6자리에는 `bcd = 0`이 들어가서, 꺼지지 않고 숫자 0이 표시됩니다.
- `seg_sel`이 클럭마다 바뀌므로, 클럭이 빠르면 잔상(ghosting)이 생길 수 있습니다.
- 조합회로 버전의 `bin2bcd`는 [bin2bcd_4bit](../bin2bcd_4bit)에 있습니다.
