# WEEK_10 — DAC

8비트 DAC(AD7302)에 디지털 값을 써서 아날로그 전압을 내는 예제입니다. 버튼으로 DAC 입력값을 1, 2, 8씩 올리고 내리며, 출력 전압은 보드 전압계 LED(VOUTA) 또는 오실로스코프(VOUTB)로 확인합니다.

| 프로젝트 | 내용 | 보고서 |
|---|---|---|
| [DAC](DAC) | 버튼 6개로 DAC 입력 ±1, ±2, ±8, DIP 스위치로 출력 A/B 선택 (교안 예제) | 예비 보고서 D, 결과 보고서 A, B |

## AD7302 제어

| 핀 | 포트 | 이 설계에서 |
|---|---|---|
| D7 ~ D0 | `dac_d[7:0]` | DAC에 쓸 값 (UP_DATA 상태에서 갱신) |
| WR (active low) | `dac_wrn` | SET_WRN에서 0, DELAY에서 1 → **상승 에지에서 D7 ~ D0을 받아 감** |
| A/B | `dac_a_b` | 0 = VOUTA, 1 = VOUTB (`add_sel`, DIP 스위치 SW2) |
| CS (active low) | `dac_csn` | 항상 0 (선택) |
| LDAC (active low) | `dac_ldacn` | 항상 0 → 입력 레지스터 값이 바로 DAC 출력에 반영 |

출력 전압은 `VOUT = VDD × D / 256` 꼴이라 0x00이면 0 V, 0xFF이면 VDD(5 V)에 가깝고, 1 LSB는 약 5 / 256 ≈ 19.5 mV입니다.

자세한 상태 흐름, 보드 연결, 시뮬레이션은 [DAC README](DAC/README.md)에 있습니다.
