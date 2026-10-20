# WEEK_7 — LED PWM 제어

| 프로젝트 | 내용 |
|---|---|
| [example1_LED_control](example1_LED_control) | DIP 스위치 8개로 단색 LED 밝기를 PWM 제어하고, 기준값을 7-segment 어레이에 10진수로 표시 (결과 보고서 5.1, 5.2) |
| [example2_LED3_control](example2_LED3_control) | 버튼 8개로 3색(RGB) LED를 무지개색·백색으로 PWM 제어 (결과 보고서 5.3, 5.4) |

## PWM 원리

8비트 카운터 `cnt`가 0 → 255 → 0 …으로 클럭마다 1씩 증가하고, 비교기가 `cnt`와 기준값(reference signal)을 비교해 LED를 켜고 끕니다. 한 PWM 주기는 256클럭입니다.

| 메인 클럭 | PWM 주기 | PWM 주파수 |
|---|---|---|
| 50 MHz | 5.12 µs | 약 195 kHz |
| 1 MHz | 256 µs | 약 3.9 kHz |
| 10 Hz | 25.6 s | 0.039 Hz (눈으로 ON/OFF가 보임) |

두 예제는 교안 코드대로 비교식이 서로 다릅니다.

| 예제 | 비교식 | duty | 기준값 0 | 기준값 255 |
|---|---|---|---|---|
| example1 | `cnt <= bin` | (bin + 1) / 256 | 1/256 (약 0.4 %) | 100 % |
| example2 | `cnt < ref` | ref / 256 | 0 % | 255/256 (약 99.6 %) |
