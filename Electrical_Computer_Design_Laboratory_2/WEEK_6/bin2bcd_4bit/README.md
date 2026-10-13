# bin2bcd_4bit

4비트 2진수(0 ~ 15)를 2자리 BCD로 바꾸는 **조합회로**입니다. [example3](../example3_7_segment_array)의 `bin2bcd`는 클럭에 맞춰 출력하는 레지스터 버전이고, 이 프로젝트는 클럭·리셋 없이 `always @(*)`로 만든 버전입니다.

## 파일

| 파일 | 내용 |
|---|---|
| `bin2bcd_4bit.srcs/sources_1/new/bin2bcd_4bit.v` | 설계 (`bin2bcd_4bit`) |
| `bin2bcd_4bit.srcs/sim_1/new/t_bin2bcd.v` | 테스트벤치 (`t_bin2bcd`) |

## 동작

- 입력 `bin[3:0]`, 출력 `bcd[7:0] = {십의 자리, 일의 자리}`
- case 문으로 0 ~ 15를 모두 나열합니다. 예: 12 → `{4'b0001, 4'b0010}`
- 조합회로라서 `bin`이 바뀌면 `bcd`가 곧바로 바뀝니다 (클럭 지연 없음).

## 시뮬레이션

- `bin`을 10 ns마다 0 → 15로 바꾸며 `bcd`를 확인하고, 160 ns에 `$finish`로 끝납니다.

## 참고

- 제약 파일은 없습니다 (시뮬레이션용).
