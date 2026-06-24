import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'widgets/payment_sheet.dart';

class PaymentRouterClient {
  final String backendUrl;
  final String userEmail;
  final String userCountryCode; // e.g. "US", "ZA", "NG"
  final bool isHuaweiDevice;
  final _uuid = const Uuid();

  PaymentRouterClient({
    required this.backendUrl,
    required this.userEmail,
    required this.userCountryCode,
    this.isHuaweiDevice = false,
  });

  /// Presents the bottom sheet selector displaying option groups based on user location
  Future<void> showPaymentSheet({
    required BuildContext context,
    required double amount,
    required String currency,
    required Function(Map<String, dynamic> successResult) onPaymentSuccess,
    required VoidCallback onPaymentCancelled,
  }) async {
    final idempotencyKey = _uuid.v4();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => PaymentMethodSheet(
        amount: amount,
        currency: currency,
        countryCode: userCountryCode,
        isHuaweiDevice: isHuaweiDevice,
        onCheckoutRequested: (option, phoneNumber) async {
          return await _initializeCheckout(
            amount: amount,
            currency: currency,
            option: option,
            idempotencyKey: idempotencyKey,
            phoneNumber: phoneNumber,
          );
        },
        onPaymentCompleted: (result) {
          onPaymentSuccess(result);
        },
        onPaymentFailed: onPaymentCancelled,
      ),
    );
  }

  Future<Map<String, dynamic>> _initializeCheckout({
    required double amount,
    required String currency,
    required PaymentOption option,
    required String idempotencyKey,
    String? phoneNumber,
  }) async {
    final url = Uri.parse("$backendUrl/payments/checkout");
    
    String apiMethodName = "card";
    if (option == PaymentOption.linkedBankApp) {
      apiMethodName = "linked_bank";
    } else if (option == PaymentOption.instantEft) {
      apiMethodName = "instant_eft";
    } else if (option == PaymentOption.appleGooglePay) {
      apiMethodName = "apple_google_pay";
    }

    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "amount": amount,
      "currency": currency.toUpperCase(),
      "email": userEmail,
      "country_code": userCountryCode.toUpperCase(),
      "payment_method": apiMethodName,
      "idempotency_key": idempotencyKey,
      if (phoneNumber != null) "phone_number": phoneNumber,
    });

    // ---------------------------------------------------------
    // OPEN SOURCE MODE: Simulated Backend Response
    // Since this is the free UI-only version, we bypass the 
    // real HTTP request to the Python backend to prevent crashes.
    // ---------------------------------------------------------
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a mock success response
    return {
      "gateway": "mock_gateway",
      "status": "success",
      "transaction_id": "mock_txn_${idempotencyKey}",
      "client_secret": "mock_secret",
      "amount": amount,
      "currency": currency,
      "message": "Simulated successful checkout from FlutterPay Open Source UI"
    };
  }
}
