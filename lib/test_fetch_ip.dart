import 'utils/fetch_ip.dart';

void main() async {
  print('=== Testing IP Fetch Functions ===\n');

  // Test IPv4
  print('1. Testing fetchPublicIPv4()...');
  final ipv4 = await fetchPublicIPv4();
  if (ipv4 != null) {
    print('✓ IPv4: $ipv4');
    print('  Valid: ${isValidIPv4(ipv4)}');
  } else {
    print('✗ Failed to fetch IPv4');
  }
  print('');

  // Test IPv6
  print('2. Testing fetchPublicIPv6()...');
  final ipv6 = await fetchPublicIPv6();
  if (ipv6 != null) {
    print('✓ IPv6: $ipv6');
    print('  Valid: ${isValidIPv6(ipv6)}');
  } else {
    print('✗ Failed to fetch IPv6 (may not be supported)');
  }
  print('');

  // Test IP Details
  print('3. Testing fetchIPDetails()...');
  final details = await fetchIPDetails();
  if (details != null) {
    print('✓ IP Details fetched successfully:');
    details.forEach((key, value) {
      print('  $key: $value');
    });
  } else {
    print('✗ Failed to fetch IP details');
  }
  print('');

  // Test IPv6 Connectivity
  print('4. Testing hasIPv6Connectivity()...');
  final hasIPv6 = await hasIPv6Connectivity();
  print('✓ IPv6 Connectivity: $hasIPv6');
  print('');

  // Test Validation Functions
  print('5. Testing validation functions...');
  print('  isValidIPv4("8.8.8.8"): ${isValidIPv4("8.8.8.8")}');
  print('  isValidIPv4("256.1.1.1"): ${isValidIPv4("256.1.1.1")}');
  print('  isValidIPv6("2001:db8::1"): ${isValidIPv6("2001:db8::1")}');
  print('  isValidIPv6("192.168.1.1"): ${isValidIPv6("192.168.1.1")}');
}