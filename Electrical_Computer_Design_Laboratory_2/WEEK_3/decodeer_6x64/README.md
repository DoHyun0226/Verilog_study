# decodeer_6x64

6×64 디코더입니다. `generate` + `for` 루프와 `genvar`로 출력 64개를 만듭니다 (`out[i] = (in == i)`).

## 파일

| 파일 | 내용 |
|---|---|
| `decodeer_6x64.srcs/sources_1/new/decoder_6x64.v` | 설계 (`decoder_6x64`) |

## 참고

- 파일 하단에 같은 동작을 `always @(*)`로 구현한 `decoder_6x64_always`가 주석으로 남아 있습니다.
- 폴더 이름의 `decodeer`는 오타지만 Vivado 프로젝트 이름과 묶여 있어 그대로 두었습니다.
- 제약 파일과 테스트벤치는 없습니다.
