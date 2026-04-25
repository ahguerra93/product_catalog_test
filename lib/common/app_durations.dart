abstract final class AppDurations {
  // Delays - Simulations
  static const Duration mockDataFetchDelay = Duration(seconds: 1);
  static const Duration mockFastFetchDelay = Duration(milliseconds: 800);
  static const Duration mockDetailFetchDelay = Duration(milliseconds: 400);

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Search/Debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
