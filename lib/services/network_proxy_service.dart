import 'package:flutter/foundation.dart' hide Category;

class NetworkProxyService {
  static const String _defaultProxy = 'https://api.allorigins.win/raw?url=';

  static Uri wrapUri(Uri uri) {
    if (!kIsWeb) return uri;
    
    // Only wrap http/https urls
    if (!uri.scheme.startsWith('http')) return uri;

    // Don't wrap if it's already a proxy or a known CORS-friendly domain like github
    final uriString = uri.toString();
    if (uriString.isEmpty) return uri;
    
    if (uriString.contains('api.allorigins.win') || 
        uriString.contains('raw.githubusercontent.com') ||
        uriString.contains('base64,')) {
      return uri;
    }

    return Uri.parse('$_defaultProxy${Uri.encodeComponent(uriString)}');
  }

  static String wrapUrl(String url) {
    if (!kIsWeb || url.isEmpty) return url;
    try {
      return wrapUri(Uri.parse(url)).toString();
    } catch (_) {
      return url;
    }
  }
}
