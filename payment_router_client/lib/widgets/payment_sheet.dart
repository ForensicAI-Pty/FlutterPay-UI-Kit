import 'package:flutter/material.dart';
import 'webview_page.dart';

enum PaymentOption {
  creditDebitCard, // Stripe (Int), Paystack (Africa)
  linkedBankApp,   // Plaid (US), Stitch (ZA), Tink (EU) - Account linking
  instantEft,      // Trustly (US), Ozow (ZA), Klarna (EU), PayNow (SG) - Direct transfer
  appleGooglePay,  // Apple Pay / Google Pay
  cash             // Pay driver in cash
}

class PaymentMethodSheet extends StatefulWidget {
  final double amount;
  final String currency;
  final String countryCode;
  final bool isHuaweiDevice;
  final Future<Map<String, dynamic>> Function(PaymentOption option, String? phoneNumber) onCheckoutRequested;
  final Function(Map<String, dynamic> result) onPaymentCompleted;
  final VoidCallback onPaymentFailed;

  const PaymentMethodSheet({
    super.key,
    required this.amount,
    required this.currency,
    required this.countryCode,
    required this.isHuaweiDevice,
    required this.onCheckoutRequested,
    required this.onPaymentCompleted,
    required this.onPaymentFailed,
  });

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  PaymentOption _selectedOption = PaymentOption.instantEft;
  bool _isProcessing = false;
  final TextEditingController _phoneController = TextEditingController();

  String get _region {
    final code = widget.countryCode.toUpperCase();
    if (const ["US", "CA"].contains(code)) return "US";
    if (const ["ZA", "NG", "KE", "GH", "EG", "RW", "CI", "SN", "TZ", "UG"].contains(code)) return "AFRICA";
    if (const ["GB", "DE", "FR", "IT", "ES", "NL", "BE", "SE", "NO", "DK", "FI", "PL"].contains(code)) return "EU";
    if (const ["SG", "TH", "IN", "CN"].contains(code)) return "ASIA";
    return "INTERNATIONAL";
  }

  bool get _isAfrica => _region == "AFRICA";

  void _handlePay() async {

    setState(() {
      _isProcessing = true;
    });

    try {
      if (_selectedOption == PaymentOption.cash) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        widget.onPaymentCompleted({"status": "success", "type": "cash"});
        return;
      }

      final response = await widget.onCheckoutRequested(_selectedOption, _phoneController.text);
      if (!mounted) return;

      if (response.containsKey('redirect_url') || response.containsKey('authorization_url')) {
        final redirectUrl = response['redirect_url'] ?? response['authorization_url'];
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentWebViewPage(
              title: _getOptionTitle(_selectedOption),
              redirectUrl: redirectUrl,
              callbackSuccessUrlPattern: "success",
              onSuccess: () {
                Navigator.of(context).pop();
                widget.onPaymentCompleted(response);
              },
              onCancel: () {
                Navigator.of(context).pop();
                widget.onPaymentFailed();
              },
            ),
          ),
        );
        return;
      }
      
      widget.onPaymentCompleted(response);
    } catch (e) {
      widget.onPaymentFailed();
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _getOptionTitle(PaymentOption option) {
    switch (option) {
      case PaymentOption.creditDebitCard:
        return "Bank Card";
      case PaymentOption.linkedBankApp:
        return "Bank Payment";
      case PaymentOption.instantEft:
        return "EFT";
      case PaymentOption.appleGooglePay:
        return "Apple / Google Pay";
      case PaymentOption.cash:
        return "Cash Payment";
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case "ZAR": return "R";
      case "USD": return "\$";
      case "EUR": return "€";
      case "GBP": return "£";
      case "NGN": return "₦";
      case "KES": return "KSh";
      default: return currency + " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final platform = Theme.of(context).platform;
    final isIOS = platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    final isAndroid = platform == TargetPlatform.android;
    final reg = _region;

    final hasLinkedBank = const ["US", "EU", "ZA"].contains(widget.countryCode.toUpperCase()) || reg == "US" || reg == "EU" || widget.countryCode.toUpperCase() == "ZA";
    final hasInstantEft = const ["US", "EU", "ZA", "SG"].contains(widget.countryCode.toUpperCase()) || reg == "US" || reg == "EU" || widget.countryCode.toUpperCase() == "ZA" || widget.countryCode.toUpperCase() == "SG";

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 16),
          Text(
            "Select Payment Option",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Total: ${_getCurrencySymbol(widget.currency)}${widget.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 1. Card Payments (Dynamic Stripe/Paystack routing based on location)
          _buildOptionTile(
            option: PaymentOption.creditDebitCard,
            title: _getOptionTitle(PaymentOption.creditDebitCard),
            icon: Icons.credit_card_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 2. One-click Bank Linking (Plaid / Tink / Stitch)
          if (hasLinkedBank) ...[
            _buildOptionTile(
              option: PaymentOption.linkedBankApp,
              title: _getOptionTitle(PaymentOption.linkedBankApp),
              icon: Icons.account_balance_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
          ],

          // Instant Bank Redirect (Trustly / Klarna / Ozow / PayNow)
          if (hasInstantEft) ...[
            _buildOptionTile(
              option: PaymentOption.instantEft,
              title: _getOptionTitle(PaymentOption.instantEft),
              icon: Icons.bolt_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
          ],

          // Apple / Google Pay
          if (!widget.isHuaweiDevice && (isIOS || isAndroid)) ...[
            _buildOptionTile(
              option: PaymentOption.appleGooglePay,
              title: isIOS ? "Apple Pay" : "Google Pay",
              icon: isIOS ? Icons.apple : Icons.android,
              isDark: isDark,
              enabled: true,
            ),
            const SizedBox(height: 12),
          ],

          // 4. Cash
          _buildOptionTile(
            option: PaymentOption.cash,
            title: _getOptionTitle(PaymentOption.cash),
            icon: Icons.payments_outlined,
            isDark: isDark,
            enabled: true,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isProcessing ? null : _handlePay,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF6C63FF) : const Color(0xFF4F46E5),
              disabledBackgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Confirm Payment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "A product of Forensic AI",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required PaymentOption option,
    required String title,
    required IconData icon,
    required bool isDark,
    bool enabled = true,
  }) {
    final isSelected = _selectedOption == option;
    return GestureDetector(
      onTap: enabled ? () {
        setState(() {
          _selectedOption = option;
        });
      } : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2C254A) : const Color(0xFFEEF2FF))
              : (isDark ? const Color(0xFF252525) : const Color(0xFFF9FAFB)),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF6C63FF) : const Color(0xFF4F46E5))
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
      ),
    );
  }
}
