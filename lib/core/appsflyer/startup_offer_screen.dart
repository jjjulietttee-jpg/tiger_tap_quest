import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiger_tap_quest/core/appsflyer/appsflyer_config.dart';
import 'package:tiger_tap_quest/core/appsflyer/appsflyer_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _kSafariUa =
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1';
const String _kChromeUa =
    'Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36';

class IntroPanelScreen extends StatefulWidget {
  const IntroPanelScreen({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  State<IntroPanelScreen> createState() => _IntroPanelScreenState();
}

class _IntroPanelScreenState extends State<IntroPanelScreen> {
  late final WebViewController _controller;
  bool _loaded = false;
  bool _dismissed = false;
  bool _loadRequested = false;
  String? _targetHost;
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();

    _watchdog = Timer(const Duration(seconds: 8), () {
      if (!_loaded && !_dismissed) _dismiss();
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final ua = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => _kSafariUa,
      TargetPlatform.android => _kChromeUa,
      _ => null,
    };

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setOnConsoleMessage((_) {})
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;
            final scheme = uri.scheme.toLowerCase();
            if (scheme == 'https' || scheme == 'http') {
              return NavigationDecision.navigate;
            }
            unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
            return NavigationDecision.prevent;
          },
          onProgress: (progress) {
            if (!_loadRequested) return;
            if (progress >= 50) _reveal();
          },
          onPageFinished: (url) {
            if (!_loadRequested) return;
            if (_isErrorUrl(url)) {
              _dismiss();
              return;
            }
            _reveal();
          },
          onWebResourceError: (error) {
            if (!_loadRequested) return;
            if (error.isForMainFrame == true) _dismiss();
          },
          onHttpError: (error) {
            if (!_loadRequested) return;
            final status = error.response?.statusCode;
            final host = error.request?.uri.host ?? '';
            if (status == null || status < 400) return;
            if (_targetHost != null && host == _targetHost) {
              _dismiss();
            }
          },
        ),
      );

    if (ua != null) {
      unawaited(_controller.setUserAgent(ua).catchError((_) {}));
    }

    _load();
  }

  bool _isErrorUrl(String url) {
    if (url.isEmpty) return false;
    final lower = url.toLowerCase();
    return lower.startsWith('chrome-error://') ||
        lower.startsWith('data:text/html,chromewebdata') ||
        lower == 'about:blank';
  }

  Future<void> _load() async {
    try {
      final hasNetwork = await _hasNetwork();
      if (!mounted || _dismissed) return;
      if (!hasNetwork) {
        _dismiss();
        return;
      }

      const originalUrl = AppsFlyerConfig.trackerUrl;
      final wasAttributionMissing =
          !AppsFlyerService.instance.isAttributionReceived;

      final resolved =
          await AppsFlyerService.instance.resolveUrl(originalUrl);
      if (!mounted || _dismissed) return;

      final uri = Uri.tryParse(resolved);
      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        _dismiss();
        return;
      }
      _targetHost = uri.host;

      final reachable = await _isReachable(uri);
      if (!mounted || _dismissed) return;
      if (!reachable) {
        _dismiss();
        return;
      }

      _loadRequested = true;
      await _controller.loadRequest(uri);

      if (wasAttributionMissing) {
        unawaited(_sendLateAttributionPing(originalUrl));
      }
    } catch (_) {
      _dismiss();
    }
  }

  Future<void> _sendLateAttributionPing(String originalUrl) async {
    try {
      await AppsFlyerService.instance.getAttribution();
    } catch (_) {
      return;
    }
    try {
      final fullUrl =
          await AppsFlyerService.instance.resolveUrl(originalUrl);
      final uri = Uri.tryParse(fullUrl);
      if (uri == null || !uri.hasScheme) return;
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 5)
        ..idleTimeout = const Duration(seconds: 5);
      try {
        final req = await client.getUrl(uri);
        req.followRedirects = true;
        final resp = await req.close();
        unawaited(resp.drain<void>(null).catchError((_) {}));
      } finally {
        client.close(force: true);
      }
    } catch (_) {}
  }

  Future<bool> _hasNetwork() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.any((c) => c != ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  Future<bool> _isReachable(Uri uri) async {
    try {
      return await _doProbe(uri).timeout(const Duration(seconds: 3));
    } catch (_) {
      return false;
    }
  }

  Future<bool> _doProbe(Uri uri) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 2)
      ..idleTimeout = const Duration(seconds: 1);
    try {
      final req = await client.getUrl(uri);
      req.followRedirects = false;
      final resp = await req.close();
      unawaited(resp.drain<void>(null).catchError((_) {}));
      return resp.statusCode < 500;
    } finally {
      client.close(force: true);
    }
  }

  void _reveal() {
    if (_loaded || _dismissed || !mounted) return;
    _watchdog?.cancel();
    setState(() => _loaded = true);
  }

  void _dismiss() {
    if (_dismissed || !mounted) return;
    _watchdog?.cancel();
    _dismissed = true;
    widget.onDismiss();
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onDismiss();
        },
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              WebViewWidget(controller: _controller),
              if (!_loaded)
                const ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
