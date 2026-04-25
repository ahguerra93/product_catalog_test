import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    // lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
  level: _getLogLevel(),
);

Level _getLogLevel() {
  const isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
  return isDebugMode ? Level.debug : Level.info;
}

class LoggerService {
  const LoggerService();

  /// Log sensitive data only in debug mode
  void logSensitiveData(String tag, dynamic data) {
    const isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    if (isDebugMode) {
      _logger.d('[$tag] $data');
    }
  }

  /// Log route navigation
  void logRouteNavigation(String routeName, {Map<String, dynamic>? params}) {
    if (params != null && params.isNotEmpty) {
      _logger.i('🔀 Navigating to: $routeName with params: $params');
    } else {
      _logger.i('🔀 Navigating to: $routeName');
    }
  }

  /// Log repository error
  void logRepositoryError(String repository, String method, Object error, StackTrace stackTrace) {
    _logger.e('❌ [$repository.$method] Error', error: error, stackTrace: stackTrace);
  }

  /// Log datasource fetch
  void logDatasourceFetch(String datasource, String method, {bool success = true, dynamic data}) {
    if (success) {
      _logger.i('✅ [$datasource.$method] Fetched successfully');
      logSensitiveData('$datasource.$method.data', data);
    } else {
      _logger.w('⚠️ [$datasource.$method] Fetch failed');
    }
  }

  /// Log data as JSON (for sensitive data in debug mode)
  void logDataAsJson(String tag, List<dynamic> items) {
    const isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
    if (isDebugMode && items.isNotEmpty) {
      final jsonData = items.map((item) => _toJson(item)).toList();
      _logger.d('📊 [$tag] Retrieved ${items.length} items:\n${jsonData.map((j) => '  - $j').join('\n')}');
    }
  }

  /// Convert entity to JSON representation
  dynamic _toJson(dynamic entity) {
    return entity.toString();
  }

  /// Log cache hit/miss
  void logCacheHit(String key, {bool hit = true}) {
    if (hit) {
      _logger.d('💾 Cache HIT: $key');
    } else {
      _logger.d('💾 Cache MISS: $key');
    }
  }

  /// Log debug message
  void debug(String message) => _logger.d(message);

  /// Log info message
  void info(String message) => _logger.i(message);

  /// Log warning message
  void warning(String message) => _logger.w(message);

  /// Log error message
  void error(String message, Object error, StackTrace stackTrace) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
