# FlutterPay UI Kit 💳

A premium, dynamically routed payment gateway UI for Flutter. Built for Ride-Hailing, Gig-Economy, and SaaS applications.

Features a sleek, Uber-style checkout experience with built-in UI routing for **Stripe**, **Paystack**, **Stitch**, and **Ozow**. Globally scalable with support for Apple Pay, Google Pay, International Cards, and Instant Bank Transfers (EFT).

---

## Features ✨

- 🚀 **Uber-Style Checkout**: Elegant, bottom-sheet driven flow designed for conversion.
- 🔀 **Dynamic Routing**: Built-in visual states for multiple global providers:
  - **Stripe**: Credit cards, Apple Pay, Google Pay, ACH, Alipay, GrabPay.
  - **Paystack**: African credit cards, mobile money, bank transfers.
  - **Stitch / Ozow**: Direct Instant EFT / bank transfers.
- 📱 **Fully Responsive**: Adapts seamlessly to Android, iOS, and Web.
- 🎨 **Premium Aesthetics**: Smooth transitions, sleek dark/light mode support, and micro-animations.
- 🔌 **Plug & Play**: Modular package structure (`payment_router_client`) with a clean integration example.

---

## Demo 🎥

Check out the included video file [FlutterPay.mp4](./FlutterPay.mp4) in this repository to see the smooth checkout flow and responsive UI in action!

---

## Project Structure 📁

- **`payment_router_client`**: The core Flutter package containing the payment sheet UI, routing controllers, and state management.
- **`example`**: A complete demonstration application showing how to trigger the payment sheet and handle payment events.

---

## Getting Started 🛠️

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Setup & Run

1. Clone this repository:
   ```bash
   git clone https://github.com/ForensicAI-Pty/FlutterPay-UI-Kit.git
   ```
2. Navigate to the example project:
   ```bash
   cd FlutterPay-UI-Kit/example
   ```
3. Get packages and run:
   ```bash
   flutter pub get
   flutter run
   ```

---

## How It Works 💡

The UI operates in **Open-Source Mode** out of the box. Instead of requiring a running backend, it uses client-side mocks to demonstrate the successful payment states for cards, EFT, and cash.

To connect it to your live endpoints, simply update the base URL in the `PaymentRouterClient` config to point to your payment router backend.

---

## Dual Licensing & Premium Backend 💼

This repository contains the **Frontend UI Kit** and is open-sourced under the MIT-style license found in the `LICENSE` file.

If you are looking to deploy this in production with a secure, production-ready backend:
- We offer a **Premium Django/FastAPI payment router backend** with native API connections, Webhook handlers, and cryptographic validation for Stripe, Paystack, Stitch, and Ozow.
- For business inquiries, licensing, or commercial support, contact us at **info@forensicai.co.za** or **# FlutterPay UI Kit 💳

A premium, dynamically routed payment gateway UI for Flutter. Built for Ride-Hailing, Gig-Economy, and SaaS applications.

Features a sleek, Uber-style checkout experience with built-in UI routing for **Stripe**, **Paystack**, **Stitch**, and **Ozow**. Globally scalable with support for Apple Pay, Google Pay, International Cards, and Instant Bank Transfers (EFT).

---

## Features ✨

- 🚀 **Uber-Style Checkout**: Elegant, bottom-sheet driven flow designed for conversion.
- 🔀 **Dynamic Routing**: Built-in visual states for multiple global providers:
  - **Stripe**: Credit cards, Apple Pay, Google Pay, ACH, Alipay, GrabPay.
  - **Paystack**: African credit cards, mobile money, bank transfers.
  - **Stitch / Ozow**: Direct Instant EFT / bank transfers.
- 📱 **Fully Responsive**: Adapts seamlessly to Android, iOS, and Web.
- 🎨 **Premium Aesthetics**: Smooth transitions, sleek dark/light mode support, and micro-animations.
- 🔌 **Plug & Play**: Modular package structure (`payment_router_client`) with a clean integration example.

---

## Demo 🎥

Check out the included video file [FlutterPay.mp4](./FlutterPay.mp4) in this repository to see the smooth checkout flow and responsive UI in action!

---

## Project Structure 📁

- **`payment_router_client`**: The core Flutter package containing the payment sheet UI, routing controllers, and state management.
- **`example`**: A complete demonstration application showing how to trigger the payment sheet and handle payment events.

---

## Getting Started 🛠️

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Setup & Run

1. Clone this repository:
   ```bash
   git clone https://github.com/ForensicAI-Pty/FlutterPay-UI-Kit.git
   ```
2. Navigate to the example project:
   ```bash
   cd FlutterPay-UI-Kit/example
   ```
3. Get packages and run:
   ```bash
   flutter pub get
   flutter run
   ```

---

## How It Works 💡

The UI operates in **Open-Source Mode** out of the box. Instead of requiring a running backend, it uses client-side mocks to demonstrate the successful payment states for cards, EFT, and cash.

To connect it to your live endpoints, simply update the base URL in the `PaymentRouterClient` config to point to your payment router backend.

---

## Dual Licensing & Premium Backend 💼

This repository contains the **Frontend UI Kit** and is open-sourced under the MIT-style license found in the `LICENSE` file.

If you are looking to deploy this in production with a secure, production-ready backend:
- We offer a **Premium Django/FastAPI payment router backend** with native API connections, Webhook handlers, and cryptographic validation for Stripe, Paystack, Stitch, and Ozow.
- For business inquiries, licensing, or commercial support, contact us at **Tshepo.Malatji@forensicai.co.za** or **https://www.forensicai.co.za**.
**.
