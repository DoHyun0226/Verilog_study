# decoder_3x8_by_decoder_2x4

Enable 입력이 있는 2×4 디코더 2개로 3×8 디코더를 구성합니다. `x[2]`가 두 디코더 중 하나를 활성화합니다.

## 파일

| 파일 | 내용 |
|---|---|
| `decoder_3x8_by_decoder_2x4.srcs/sources_1/new/decoder_3x8_with_decoder_2x4.v` | 최상위 (`decoder_3x8_with_decoder_2x4`) |
| `decoder_3x8_by_decoder_2x4.srcs/sources_1/new/decoder_2x4_withEN.v` | 하위 모듈 (`decoder_2x4_withEN`) |
| `decoder_3x8_by_decoder_2x4.srcs/sim_1/new/t_decoder_3x8_with_decoder_2x4.v` | 테스트벤치 |

## 참고

- `decoder_2x4_withEN`은 **active-low**입니다. `EN = 0`일 때 동작하고, 선택된 출력만 0이 됩니다. `EN = 1`이면 출력이 모두 1입니다.
- `x[2] = 0`이면 하위 디코더(`D[3:0]`), `x[2] = 1`이면 상위 디코더(`D[7:4]`)가 동작합니다.
- 제약 파일은 없습니다 (시뮬레이션 전용).
