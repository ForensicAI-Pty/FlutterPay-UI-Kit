import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String title;
  final String redirectUrl;
  final String callbackSuccessUrlPattern;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const PaymentWebViewPage({
    super.key,
    required this.title,
    required this.redirectUrl,
    required this.callbackSuccessUrlPattern,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains(widget.callbackSuccessUrlPattern) || 
                request.url.contains("/success")) {
              widget.onSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.contains("/cancel") || request.url.contains("/error")) {
              widget.onCancel();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.lock_outline, 
              size: 20, 
              color: isDark ? Colors.greenAccent : Colors.green
            ),
            const SizedBox(width: 8),
            Text(
              widget.title, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onCancel,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: isDark ? const Color(0xFF121212).withOpacity(0.9) : Colors.white.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? const Color(0xFF6C63FF) : const Color(0xFF4F46E5)
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Securing connection to bank...",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
