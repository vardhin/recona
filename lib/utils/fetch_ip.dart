import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fetches the public IPv4 address with fallback APIs
/// Returns the IPv4 address as a String, or null if unable to fetch
Future<String?> fetchPublicIPv4() async {
  final apis = [
    _IPv4API(
      url: 'https://api.ipify.org?format=json',
      parser: (body) => json.decode(body)['ip'] as String?,
    ),
    _IPv4API(
      url: 'https://api4.my-ip.io/ip.json',
      parser: (body) => json.decode(body)['ip'] as String?,
    ),
    _IPv4API(
      url: 'https://ipv4.icanhazip.com',
      parser: (body) => body.trim(),
    ),
    _IPv4API(
      url: 'https://api.seeip.org/jsonip?type=ipv4',
      parser: (body) => json.decode(body)['ip'] as String?,
    ),
    _IPv4API(
      url: 'https://ipv4.wtfismyip.com/text',
      parser: (body) => body.trim(),
    ),
    _IPv4API(
      url: 'https://checkip.amazonaws.com',
      parser: (body) => body.trim(),
    ),
  ];

  for (final api in apis) {
    try {
      final response = await http.get(
        Uri.parse(api.url),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final ip = api.parser(response.body);
        if (ip != null && isValidIPv4(ip)) {
          return ip;
        }
      }
    } catch (e) {
      print('Failed to fetch IPv4 from ${api.url}: $e');
      continue;
    }
  }
  
  print('Error: All IPv4 APIs failed');
  return null;
}

/// Fetches the public IPv6 address with fallback APIs
/// Returns the IPv6 address as a String, or null if unable to fetch
Future<String?> fetchPublicIPv6() async {
  final apis = [
    _IPv6API(
      url: 'https://api64.ipify.org?format=json',
      parser: (body) => json.decode(body)['ip'] as String?,
    ),
    _IPv6API(
      url: 'https://ipv6.icanhazip.com',
      parser: (body) => body.trim(),
    ),
    _IPv6API(
      url: 'https://api.seeip.org/jsonip?type=ipv6',
      parser: (body) => json.decode(body)['ip'] as String?,
    ),
    _IPv6API(
      url: 'https://ipv6.wtfismyip.com/text',
      parser: (body) => body.trim(),
    ),
    _IPv6API(
      url: 'https://v6.ident.me',
      parser: (body) => body.trim(),
    ),
  ];

  for (final api in apis) {
    try {
      final response = await http.get(
        Uri.parse(api.url),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final ip = api.parser(response.body);
        // Verify it's actually IPv6
        if (ip != null && isValidIPv6(ip)) {
          return ip;
        }
      }
    } catch (e) {
      print('Failed to fetch IPv6 from ${api.url}: $e');
      continue;
    }
  }
  
  print('Error: All IPv6 APIs failed');
  return null;
}

/// Fetches detailed IP information including location and ISP with fallback APIs
/// Returns a Map with IP details, or null if unable to fetch
Future<Map<String, dynamic>?> fetchIPDetails({String? ip}) async {
  final apis = [
    _IPDetailsAPI(
      url: ip != null 
          ? 'http://ip-api.com/json/$ip'
          : 'http://ip-api.com/json/',
      parser: (body) => json.decode(body) as Map<String, dynamic>,
    ),
    _IPDetailsAPI(
      url: ip != null
          ? 'https://ipapi.co/$ip/json/'
          : 'https://ipapi.co/json/',
      parser: (body) => json.decode(body) as Map<String, dynamic>,
    ),
    _IPDetailsAPI(
      url: ip != null
          ? 'https://freeipapi.com/api/json/$ip'
          : 'https://freeipapi.com/api/json',
      parser: (body) => json.decode(body) as Map<String, dynamic>,
    ),
  ];

  for (final api in apis) {
    try {
      final response = await http.get(
        Uri.parse(api.url),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = api.parser(response.body);
        if (data != null && data.isNotEmpty) {
          return data;
        }
      }
    } catch (e) {
      print('Failed to fetch IP details from ${api.url}: $e');
      continue;
    }
  }
  
  print('Error: All IP details APIs failed');
  return null;
}

/// Checks if the current network has IPv6 connectivity
Future<bool> hasIPv6Connectivity() async {
  final ipv6 = await fetchPublicIPv6();
  return ipv6 != null && ipv6.contains(':');
}

/// Validates if a string is a valid IPv4 address
bool isValidIPv4(String ip) {
  final regex = RegExp(
    r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
  );
  return regex.hasMatch(ip);
}

/// Validates if a string is a valid IPv6 address
bool isValidIPv6(String ip) {
  final regex = RegExp(
    r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$'
  );
  return regex.hasMatch(ip);
}

// Helper classes for API configuration
class _IPv4API {
  final String url;
  final String? Function(String body) parser;

  _IPv4API({required this.url, required this.parser});
}

class _IPv6API {
  final String url;
  final String? Function(String body) parser;

  _IPv6API({required this.url, required this.parser});
}

class _IPDetailsAPI {
  final String url;
  final Map<String, dynamic>? Function(String body) parser;

  _IPDetailsAPI({required this.url, required this.parser});
}