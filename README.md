# Verilog

Xilinx Vivado로 작성한 Verilog HDL 실습·과제 모음입니다.

## 폴더 구조

```
Verilog/
├── Digital Design/                          # 교재 "Digital Design" 장별 예제·연습문제
│   ├── chapter 4/
│   ├── chapter 5/
│   ├── chapter 6/                           # Problem 6.31, 6.34, 6.35(b), 6.40, 6.47
│   └── chapter 7/                           # Example 7.1
├── Electrical_Computer_Design_Laboratory_2/ # 전기전자컴퓨터설계실험 2 (주차별)
│   ├── WEEK_2/   # 논리 게이트, 반가산기, 전가산기
│   ├── WEEK_3/   # 비교기, MUX, 디코더, 우선순위 인코더
│   ├── WEEK_4/   # SR 래치, D/JK/T 플립플롭, 예비 보고서
│   └── WEEK_5/   # 순차 회로 (SM1)
├── Logic_and_Computer_Design_Fundamentals/  # 교재 "Logic and Computer Design Fundamentals"
│   ├── ch2/
│   └── Example/
└── Others/                                  # 레지스터, 카운터, 시퀀스 검출기 등 개별 연습
```

## Vivado 프로젝트 구성

각 프로젝트 폴더는 다음과 같은 구조입니다.

| 경로 | 내용 |
|---|---|
| `<프로젝트>.xpr` | Vivado 프로젝트 파일 |
| `<프로젝트>.srcs/sources_1/` | 설계 소스 (`.v`) |
| `<프로젝트>.srcs/sim_1/` | 테스트벤치 (`.v`) |
| `<프로젝트>.srcs/constrs_1/` | 제약 파일 (`.xdc`) |

합성·구현·시뮬레이션 결과물(`*.runs/`, `*.sim/`, `*.cache/` 등)과 로그는 `.gitignore`로 제외되어 있습니다.

## 사용 방법

1. Vivado에서 **Open Project**를 선택한 뒤 원하는 폴더의 `.xpr` 파일을 엽니다.
2. **Run Simulation**으로 테스트벤치를 실행하거나, **Generate Bitstream**으로 비트스트림을 생성합니다.
   빌드 결과물은 로컬에서만 생성되며 저장소에는 올라가지 않습니다.
