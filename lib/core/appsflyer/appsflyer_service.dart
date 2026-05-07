import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_tap_quest/core/appsflyer/appsflyer_config.dart';

class AppsFlyerService {
  AppsFlyerService._();
  static final AppsFlyerService instance = AppsFlyerService._();

  static const String _customerUserIdKey = 'af_customer_user_id';
  static const String _attrCacheKey = 'af_attribution_v1';

  bool _initialized = false;
  AppsflyerSdk? _sdk;

  String? _cachedUid;
  String? _customerUserId;

  bool _attributionReceived = false;
  Map<String, String> _attribution = {};
  final Completer<Map<String, String>> _attributionCompleter =
      Completer<Map<String, String>>();

  bool get isInitialized => _initialized;
  bool get isAttributionReceived => _attributionReceived;
  String? get appsFlyerUid => _cachedUid;
  String? get customerUserId => _customerUserId;
  String get installSource => _attribution['install_source'] ?? 'unknown';
  String get mediaSource => _attribution['media_source'] ?? '';
  String get afStatus => _attribution['af_status'] ?? '';
  String get campaign => _attribution['campaign'] ?? '';
  String get campaignId => _attribution['campaign_id'] ?? '';
  String get adset => _attribution['adset'] ?? '';
  String get adsetId => _attribution['adset_id'] ?? '';
  String get channel => _attribution['channel'] ?? '';

  Future<void> init() async {
    if (_initialized) return;

    await _ensureCustomerUserId();
    await _restoreCachedAttribution();

    if (AppsFlyerConfig.devKey.isEmpty) {
      _completeAttribution({});
      _initialized = true;
      return;
    }

    final options = AppsFlyerOptions(
      afDevKey: AppsFlyerConfig.devKey,
      appId: Platform.isIOS ? AppsFlyerConfig.iosAppId : '',
      showDebug: false,
      timeToWaitForATTUserAuthorization: 0,
    );

    _sdk = AppsflyerSdk(options);

    _sdk!.onInstallConversionData(_parseConversionData);

    await _sdk!.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: false,
      registerOnDeepLinkingCallback: false,
    );

    _initialized = true;

    if (_customerUserId != null && _customerUserId!.isNotEmpty) {
      try {
        _sdk!.setCustomerUserId(_customerUserId!);
      } catch (_) {}
    }

    unawaited(_warmUpUid());
  }

  void _parseConversionData(dynamic rawData) {
    final top = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};

    final topStatus = (top['status'] ?? '').toString().toLowerCase();
    final payload = top['data'] ?? top['payload'];
    final map = payload is Map ? Map<String, dynamic>.from(payload) : top;
    final innerStatus = (map['status'] ?? '').toString().toLowerCase();

    if (topStatus == 'failure' || innerStatus == 'failure') return;

    if (_attributionReceived) return;

    String str(String key) => (map[key] ?? '').toString().trim();

    final mediaSource = str('media_source');
    final afStatus = str('af_status');

    _completeAttribution({
      'media_source': mediaSource,
      'af_status': afStatus,
      'campaign_id': str('campaign_id'),
      'campaign': str('campaign'),
      'adset': str('adset'),
      'adset_id': str('adset_id'),
      'channel': str('channel'),
      'install_source': _normalizeSource(mediaSource, afStatus),
    });
  }

  String _normalizeSource(String mediaSource, String afStatus) {
    final status = afStatus.toLowerCase();
    if (status == 'organic') return 'organic';
    final ms = mediaSource.toLowerCase();
    if (ms.contains('google') ||
        ms.contains('adwords') ||
        ms.contains('googleads')) {
      return 'google_ads';
    }
    if (ms.contains('apple') ||
        ms.contains('asa') ||
        ms.contains('searchads')) {
      return 'asa';
    }
    if (ms.contains('facebook') ||
        ms.contains('meta') ||
        ms.contains('instagram')) {
      return 'meta';
    }
    if (status == 'non-organic') return 'other_paid';
    if (ms.isNotEmpty) return 'other_paid';
    return 'unknown';
  }

  void _completeAttribution(Map<String, String> data) {
    if (_attributionReceived) {
      final hadSource = (_attribution['media_source'] ?? '').isNotEmpty;
      final hasSource = (data['media_source'] ?? '').isNotEmpty;
      if (!hadSource && hasSource) {
        _attribution = data;
        unawaited(_persistAttribution(data));
      }
      return;
    }
    _attributionReceived = true;
    _attribution = data;
    if (!_attributionCompleter.isCompleted) {
      _attributionCompleter.complete(data);
    }
    if ((data['media_source'] ?? '').isNotEmpty ||
        (data['af_status'] ?? '').isNotEmpty) {
      unawaited(_persistAttribution(data));
    }
  }

  Future<Map<String, String>> getAttribution() {
    if (_attributionReceived) return Future.value(_attribution);
    return _attributionCompleter.future;
  }

  Future<String?> getAppsFlyerUID() async {
    if (_cachedUid != null && _cachedUid!.isNotEmpty) return _cachedUid;
    if (!_initialized || _sdk == null) return null;
    try {
      final uid = await _sdk!.getAppsFlyerUID();
      if (uid != null && uid.isNotEmpty) {
        _cachedUid = uid;
      }
      return _cachedUid;
    } catch (_) {
      return _cachedUid;
    }
  }

  Future<String> resolveUrl(String url) async {
    if (url.isEmpty) return url;

    await _ensureCustomerUserId();
    final attr =
        _attributionReceived ? _attribution : const <String, String>{};
    final uid = await getAppsFlyerUID() ?? '';
    final cuid = _customerUserId ?? '';

    String enc(String v) => Uri.encodeQueryComponent(v);

    final installSrc = attr['install_source'] ?? 'unknown';
    final mediaSrc = attr['media_source'] ?? '';
    final afStat = attr['af_status'] ?? '';
    final campaignName = attr['campaign'] ?? '';
    final campaignIdent = attr['campaign_id'] ?? '';
    final adsetName = attr['adset'] ?? '';
    final adsetIdent = attr['adset_id'] ?? '';
    final channelName = attr['channel'] ?? '';

    final replacements = <String, String>{
      '{sub_id_1}': enc(uid),
      '{appsflyer_id}': enc(uid),
      '<appsflyer_id>': enc(uid),
      '{sub_id_2}': enc(installSrc),
      '{install_source}': enc(installSrc),
      '<install_source>': enc(installSrc),
      '{sub_id_3}': enc(mediaSrc),
      '{media_source}': enc(mediaSrc),
      '{media_source_raw}': enc(mediaSrc),
      '{sub_id_4}': enc(afStat),
      '{af_status}': enc(afStat),
      '{sub_id_5}': enc(campaignIdent),
      '{campaign_id}': enc(campaignIdent),
      '{sub_id_6}': enc(campaignName),
      '{campaign}': enc(campaignName),
      '{campaign_name}': enc(campaignName),
      '{sub_id_7}': enc(adsetIdent),
      '{adset_id}': enc(adsetIdent),
      '{adgroup_id}': enc(adsetIdent),
      '{sub_id_8}': enc(adsetName),
      '{adset}': enc(adsetName),
      '{adset_name}': enc(adsetName),
      '{adgroup}': enc(adsetName),
      '{sub_id_9}': enc(channelName),
      '{channel}': enc(channelName),
      '{sub_id_10}': enc(cuid),
      '{customer_user_id}': enc(cuid),
      '<customer_user_id>': enc(cuid),
    };

    var out = url;
    replacements.forEach((key, value) {
      out = out.replaceAll(key, value);
    });
    return out;
  }

  void logEvent(String name, [Map<String, dynamic>? values]) {
    if (!_initialized || _sdk == null || name.isEmpty) return;
    try {
      _sdk!.logEvent(name, values ?? {});
    } catch (_) {}
  }

  Future<void> _ensureCustomerUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var stored = prefs.getString(_customerUserIdKey);
      if (stored == null || stored.isEmpty) {
        stored = _generateId();
        await prefs.setString(_customerUserIdKey, stored);
      }
      _customerUserId = stored;
    } catch (_) {
      _customerUserId = _generateId();
    }
  }

  String _generateId() {
    final rng = math.Random.secure();
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final r =
        List.generate(12, (_) => rng.nextInt(36).toRadixString(36)).join();
    return '$ts$r';
  }

  Future<void> _restoreCachedAttribution() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_attrCacheKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      final attr = <String, String>{};
      decoded.forEach((k, v) {
        attr[k.toString()] = v?.toString() ?? '';
      });
      if (attr.isEmpty) return;
      _attribution = attr;
      if (!_attributionReceived) {
        _attributionReceived = true;
      }
      if (!_attributionCompleter.isCompleted) {
        _attributionCompleter.complete(attr);
      }
    } catch (_) {}
  }

  Future<void> _persistAttribution(Map<String, String> attr) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_attrCacheKey, jsonEncode(attr));
    } catch (_) {}
  }

  Future<void> _warmUpUid() async {
    await getAppsFlyerUID();
  }
}
