## 🔁 Feature: Wallet Transaction

`feature/wallet-transaction` 브랜치에서는 Flutter 기반 지갑 앱에 **Polygon Testnet 송금 기능**을 구현했습니다. 사용자는 지갑 간 C2C 이체를 안전하고 직관적으로 실행할 수 있습니다.

---

### 📌 주요 기능 구성

#### 1. **QR 코드 기반 주소 송/수신**

- 내 지갑 주소를 QR로 생성하여 타인에게 공유
- 상대방의 QR 코드를 카메라로 스캔하여 주소 자동 입력

#### 2. **송금 흐름 (3단계)**

1. **수신자 선택**
   - 최근 보낸 주소 리스트 표시
   - QR 코드 스캔 or 직접 입력

2. **이체 금액 입력**
   - 지원 토큰(예: `POL`, `ETH`) 중 선택
   - 전송 수수료 표시

3. **송금 확인**
   - 수신 주소, 이체 토큰 및 수량, 수수료 요약
   - "보내기" 버튼 클릭 시 트랜잭션 실행

---

### 🧱 사용된 기술 스택

| 항목 | 기술 |
|------|------|
| 모바일 프레임워크 | Flutter |
| 상태관리 | Provider (MVVM 패턴 적용) |
| QR 코드 생성/스캔 | `qr_flutter`, `mobile_scanner` |
| 블록체인 인터랙션 | `web3dart`, Polygon Amoy Testnet |
| 비동기 트랜잭션 처리 | `async/await` + `sendTransaction()` |

---

### 🧪 테스트 환경

- **Polygon Amoy Testnet**
- `chainId`: `80002`
- Faucet 사용 후 테스트 토큰 전송 완료

---

### 📂 주요 디렉토리 구조

```bash
lib/
├── viewmodels/
│   └── transaction_viewmodel.dart
├── presentation/
│   ├── screens/
│   │   ├── send/
│   │   │   ├── select_recipient_screen.dart
│   │   │   ├── input_amount_screen.dart
│   │   │   └── confirm_transaction_screen.dart
│   └── qr/
│       └── qr_scan_screen.dart
