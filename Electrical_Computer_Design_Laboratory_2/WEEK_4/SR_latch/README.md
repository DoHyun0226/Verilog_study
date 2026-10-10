# SR_latch

`assign`문의 피드백(`Q = (S | Q) & ~R`)으로 만든 SR 래치입니다. R이 S보다 우선합니다 (S = R = 1이면 Q = 0).

## 파일

| 파일 | 내용 |
|---|---|
| `SR_latch.srcs/sources_1/new/SR_latch.v` | 설계 (`SR_latch`) |
| `SR_latch.srcs/sim_1/new/t_SR_latch.v` | 테스트벤치 |

## 참고

출력이 자기 자신을 입력으로 쓰는 조합 루프이므로, 합성 시 Vivado가 combinational loop 경고를 낼 수 있습니다. 제약 파일은 없습니다.
