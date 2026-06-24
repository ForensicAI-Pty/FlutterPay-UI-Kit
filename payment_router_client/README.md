<div align="center">
  <img src="assets/flutterpay_logo.png" width="120" alt="FlutterPay Logo" />
  <h1>FlutterPay</h1>
  <p><strong>A dynamic, multi-gateway global payment router for Flutter.</strong></p>
  <p><i>A product of Forensic AI</i></p>
</div>

## Overview
FlutterPay is a highly secure, smart payment routing system designed to dynamically switch between payment gateways (Stripe, Paystack, Stitch, Ozow) based on the user's geographical location. It provides a sleek, unified frontend UI for Flutter, and securely delegates API communication and webhook handling to a robust Python/FastAPI backend.

## Key Features
- 🌍 **Global Smart Routing**: Instantly detects user country and offers appropriate payment methods (e.g., Stripe for US/International, Paystack for West Africa, Stitch/Ozow for South Africa).
- 🔒 **Zero Vendor Lock-in**: Add or swap out gateways directly in your backend without pushing new updates to the Google Play Store or App Store.
- 🛡️ **Network Idempotency**: Automatically handles network drops. Generates unique UUIDs (`idempotency_key`) per checkout session and utilizes exponential backoff retries to guarantee customers are never charged twice for the same transaction.
- 💸 **Crypto Ready**: Because FlutterPay hooks into Stripe natively, you can instantly accept USDC on Ethereum, Solana, or Polygon just by toggling a switch in your Stripe dashboard. No extra code required.

## Installation & Setup

### 1. Flutter Client
Add FlutterPay to your Flutter project's `pubspec.yaml`:
```yaml
dependencies:
  flutterpay:
    path: path/to/flutterpay
```

Import and invoke the payment sheet:
```dart
import 'package:flutterpay/payment_router_client.dart';

final client = PaymentRouterClient(
  backendUrl: "https://your-backend-api.com",
  userEmail: "customer@domain.com",
  userCountryCode: "ZA", // Automatically switches gateways based on this
);

client.showPaymentSheet(
  context: context,
  amount: 50.00,
  currency: "ZAR",
  onPaymentSuccess: (result) => print("Success!"),
  onPaymentCancelled: () => print("Cancelled"),
);
```

### 2. Backend Gateway Keys (Python FastAPI)
All API keys must remain strictly on the backend. Do not embed keys in Flutter.
1. Navigate to the `backend/` directory.
2. Rename `.env.example` to `.env`.
3. Fill in your live/test keys for the gateways you wish to support:

```env
STRIPE_SECRET_KEY=sk_test_...
PAYSTACK_SECRET_KEY=sk_test_...
STITCH_CLIENT_ID=client_...
OZOW_SITE_CODE=site_...
```

## Security Best Practices
- The Flutter client utilizes `UUIDv4` to generate an idempotency key upon opening the sheet. If a 500 error or network timeout occurs, the client automatically retries up to 3 times. The backend forwards this key to Stripe/Paystack to strictly enforce idempotency.
- Never expose the `backend/.env` file. Add it to your `.gitignore`.

## License
Modified MIT License with Security Disclosure Clause. See `LICENSE` for more information.
