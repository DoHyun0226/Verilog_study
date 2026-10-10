# example3_7_segment_array

버튼을 누를 때마다 0~15를 세고, 그 값을 **8자리 7-segment 어레이**의 오른쪽 두 자리에 10진수로 표시합니다 (예: `00000012`).

## 파일

| 파일 | 내용 |
|---|---|
| `example3_7_segment_array.srcs/sources_1/new/seg_array.v` | 최상위 (`seg_array`) |
| `example3_7_segment_array.srcs/sources_1/new/bin2bcd.v` | 4비트 2진수 → 2자리 BCD 변환 (`bin2bcd`) |
| `example3_7_segment_array.srcs/sources_1/new/one_shot_universal.v` | one-shot trigger. [example2](../example2_7_segment)에서 복사함 |

## 동작

1. `one_shot_universal #(.WIDTH(1))`이 버튼의 상승 에지를 검출합니다.
2. `state_bin`이 버튼을 누를 때마다 1씩 증가합니다 (15 다음에는 0).
3. `bin2bcd`가 `state_bin`을 BCD로 바꿉니다. `state_bcd = {십의 자리, 일의 자리}`, 예: 12 → `{4'd1, 4'd2}`
4. `seg_sel`이 클럭마다 왼쪽으로 회전하며 8자리를 차례로 선택합니다 (active-low, `8'b11111110`부터 시작). 이 방식을 **다이내믹 구동**이라고 합니다.
5. 자리 선택 블록(조합회로)이 선택된 자리에 맞는 숫자를 `bcd`에 넣습니다. 0번째 자리는 일의 자리, 1번째 자리는 십의 자리, 나머지는 0입니다.
6. 디코더(조합회로)가 `bcd`를 7-segment 패턴 `seg_data = {a, b, c, d, e, f, g, dp}` (active-high)로 바꿉니다.

5번과 6번은 `always @(*)` 조합회로입니다. 그래서 `seg_sel`이 바뀐 같은 클럭 안에 `seg_data`도 따라 바뀌고, 자리와 숫자가 어긋나지 않습니다.

## 참고

- 사용하지 않는 6자리에는 `bcd = 0`이 들어가서, 꺼지지 않고 숫자 0이 표시됩니다.
- `seg_sel`이 클럭마다 바뀌므로, 클럭이 빠르면 잔상(ghosting)이 생길 수 있습니다.
- 제약 파일은 아직 없습니다.
