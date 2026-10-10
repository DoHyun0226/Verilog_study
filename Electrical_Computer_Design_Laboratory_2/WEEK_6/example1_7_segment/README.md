# example1_7_segment

버튼을 누를 때마다 7-segment에 표시되는 숫자가 1씩 증가합니다 (0 → 1 → … → 9 → 0).

## 파일

| 파일 | 내용 |
|---|---|
| `example1_7_segment.srcs/sources_1/new/seg_counter.v` | 최상위 (`seg_counter`) |
| `example1_7_segment.srcs/sources_1/new/one_shot.v` | 1비트 one-shot trigger (`one_shot`) |
| `example1_7_segment.srcs/sources_1/new/seg_counter_modified.v` | 수정 버전 (`seg_counter_modified`) |
| `example1_7_segment.srcs/sources_1/new/one_shot_modified.v` | 수정 버전 (`one_shot_modified`) |

## 동작

1. `one_shot`이 버튼의 상승 에지에서 `btn_trig`를 1클럭 동안 1로 만듭니다.
2. `btn_trig`가 1이면 `state`(0~9)가 1 증가하고, 9 다음에는 0으로 돌아갑니다.
3. 디코더가 `state`를 7-segment 패턴 `seg = {a, b, c, d, e, f, g, dp}` (active-high)로 바꿉니다.

## 수정 버전

`one_shot_modified`는 이전 클럭의 `btn`만 저장하고, 에지 검출(`btn == 1 && btn_trig == 0`)은 `seg_counter_modified` 안에서 합니다. 레지스터가 하나 줄어 1클럭 빨리 반응합니다.

`seg_counter_modified.v`는 `one_shot_modified`를 포트 5개로 연결하지만, `one_shot_modified`의 포트는 4개입니다. Vivado에서 포트 수 불일치 오류나 경고가 날 수 있습니다.

제약 파일은 아직 없습니다.
