class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> track(String eventName, Map<String, dynamic> properties) async {
    // Send to analytics service (Firebase Analytics, Mixpanel, etc.)
    print('Analytics: $eventName - $properties');
    
    // Example with Firebase:
    // await FirebaseAnalytics.instance.logEvent(
    //   name: eventName,
    //   parameters: properties,
    // );
  }
}