class AppRoutes {
  // Splash & Auth
  static const String splash = 'splash';
  static const String login = 'login';

  // Home
  static const String home = 'home';
  // ملحوظة: لو الـ Map و الـ CustomerDetails بيتفتحوا بـ push عادي برضه، شيلهم.
  static const String map = 'map';
  static const String customerDetails = 'customerDetails';

  // Profile
  static const String profile = 'profile';
  // شيلنا reports و dashboard و deals لأنهم مابقوش Routes معرفين في GoRouter

  // More
  // لو الـ settings و الـ addClient بيتفتحوا من الـ Router سيبهم، لو Navigator شيلهم
  static const String settings = 'settings';
  static const String addClient = 'addClient';
  static const String appInfo = 'appInfo';

  // Chat
  static const String chat = 'chat';
}