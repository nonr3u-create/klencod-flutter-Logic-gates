import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF020617),
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const TransistorLabApp());
}

class TransistorLabApp extends StatelessWidget {
  const TransistorLabApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransistorLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020617),
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final html = await rootBundle.loadString('assets/index.html');
      final c = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF020617))
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (e) {
            debugPrint('WV error: ${e.description}');
          },
        ));
      // تحميل HTML كسلسلة نصية - أكثر موثوقية من loadFlutterAsset
      await c.loadHtmlString(html, baseUrl: 'https://localhost/');
      if (!mounted) return;
      setState(() {
        _controller = c;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'خطأ: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_controller != null && await _controller!.canGoBack()) {
          await _controller!.goBack();
        } else if (mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)))
              : _error.isNotEmpty
                  ? Center(child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(_error, style: const TextStyle(color: Colors.red)),
                    ))
                  : _controller != null
                      ? WebViewWidget(controller: _controller!)
                      : const Center(child: Text('لا يوجد محتوى', style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}