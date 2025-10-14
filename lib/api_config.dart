import 'dart:io' show Platform;

String apiBaseUrl() {
  try {
    if (Platform.isAndroid) return 'http://10.0.2.2';
    if (Platform.isIOS) return 'http://127.0.0.1';
    return 'http://127.0.0.1';
  } catch (_) {
    // Web or unknown platform
    return 'http://127.0.0.1';
  }
}
