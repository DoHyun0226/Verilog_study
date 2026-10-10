# 1-bit_comparator

1비트 크기 비교기입니다. 논리식으로 `a > b`, `a == b`, `a < b`를 각각 출력합니다.

## 파일

| 파일 | 내용 |
|---|---|
| `1-bit_comparator.srcs/sources_1/new/compartor_1bit.v` | 설계 (`compartor_1bit`) |

## 입출력

| 포트 | 의미 |
|---|---|
| `a`, `b` | 비교할 1비트 입력 |
| `x` | `a > b` (`a & !b`) |
| `y` | `a == b` |
| `z` | `a < b` (`!a & b`) |

제약 파일과 테스트벤치는 없습니다.
