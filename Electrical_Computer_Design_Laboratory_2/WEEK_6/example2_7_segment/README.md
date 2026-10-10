# example2_7_segment

버튼 10개 중 `btn[n]`을 누르면 7-segment에 숫자 `n`이 표시됩니다.

## 파일

| 파일 | 내용 |
|---|---|
| `example2_7_segment.srcs/sources_1/new/seg_btn.v` | 최상위 (`seg_btn`) |
| `example2_7_segment.srcs/sources_1/new/one_shot_universal.v` | 파라미터 폭 one-shot trigger (`one_shot_universal`) |

## 동작

1. `one_shot_universal #(.WIDTH(10))`이 버튼 10개 각각의 상승 에지를 검출해 `btn_trig[9:0]`을 만듭니다.
2. if-else if 사슬이 `btn_trig`에서 1인 비트의 번호를 `state`에 저장합니다. 여러 버튼이 동시에 눌리면 **번호가 작은 버튼**이 우선합니다. 아무것도 눌리지 않으면 `state`를 유지합니다.
3. 디코더가 `state`를 7-segment 패턴 `seg = {a, b, c, d, e, f, g, dp}` (active-high)로 바꿉니다.

세 단계가 모두 레지스터라서, 버튼을 누른 뒤 `seg`가 바뀌기까지 클럭 에지 3번이 걸립니다.

## one_shot_universal

`parameter WIDTH`로 폭을 정하는 범용 one-shot입니다. 인스턴스에서 `one_shot_universal #(.WIDTH(n)) 이름(clk, rst, btn, btn_trig);`처럼 폭을 지정합니다. 리셋값 `{WIDTH{1'b0}}`는 복제 연산자로, WIDTH가 몇이든 폭이 맞는 0을 만듭니다.

제약 파일은 아직 없습니다.
