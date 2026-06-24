import 'package:flutter/material.dart';
import 'package:flutterpay/payment_router_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterPay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF111827),
      ),
      themeMode: ThemeMode.system,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  void _startPayment(BuildContext context) {
    double baseAmount = 50.0;

    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    String countryCode = locale.countryCode ?? "US";
    String currency = "USD";
    
    if (countryCode == "ZA") {
      currency = "ZAR";
      baseAmount = baseAmount * 18; 
    } else if (const ["NG", "KE", "GH", "EG"].contains(countryCode)) {
      currency = countryCode == "NG" ? "NGN" : (countryCode == "KE" ? "KES" : "USD");
      baseAmount = baseAmount * 1000;
    }

    final client = PaymentRouterClient(
      backendUrl: "http://127.0.0.1:8000",
      userEmail: "customer@domain.com",
      userCountryCode: countryCode,
    );

    client.showPaymentSheet(
      context: context,
      amount: baseAmount,
      currency: currency,
      onPaymentSuccess: (res) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SuccessPage()),
        );
      },
      onPaymentCancelled: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment was cancelled")),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Written Logo
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Flutter',
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      ),
                      const TextSpan(
                        text: 'Pay',
                        style: TextStyle(color: Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Ride Options",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
                        border: Border.all(color: isDark ? Colors.white24 : Colors.black87, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Premium Ride", 
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold, 
                                  color: isDark ? Colors.white : Colors.black87
                                )
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Arrives in 3 mins", 
                                style: TextStyle(
                                  fontSize: 14, 
                                  color: isDark ? Colors.white54 : Colors.black54
                                )
                              ),
                            ],
                          ),
                          Text(
                            "\$50.00", 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: isDark ? Colors.white : Colors.black87
                            )
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _startPayment(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text("Request Ride", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                  children: [
                    TextSpan(
                      text: 'Flutter',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const TextSpan(
                      text: 'Pay',
                      style: TextStyle(color: Color(0xFF4F46E5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Thank you for your business. Your transaction has been securely processed.",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LandingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text("Back to Home", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
