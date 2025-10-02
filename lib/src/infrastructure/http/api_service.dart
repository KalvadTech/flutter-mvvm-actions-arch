import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '/src/core/errors/app_exception.dart';
import '/src/essentials/config/api_config.dart';
import '/src/infrastructure/storage/memory_service.dart';
import '/src/infrastructure/cache/cache_manager.dart';

/// **ApiService**
///
/// Central HTTP service that performs API calls, handles authorization,
/// retries on unauthorized responses, maps errors to typed exceptions,
/// and optionally coordinates request/response caching.
///
/// **Why**
/// - Provide a single place to enforce networking standards (headers, retry,
///   logging, error mapping) across feature services.
/// - Keep caching transport-agnostic by delegating to a [CacheManager] that
///   stores raw strings, while decoding happens here at the call site.
///
/// **Key Features**
/// - Authorization header builder with correct formatting.
/// - One-shot 401 refresh with retry of the original request.
/// - Robust error handling that does not throw secondary decode errors.
/// - Redacted, assert-gated debug logging.
/// - Pluggable global cache via [configureCache] using [CacheManager].
///
/// **Example**
/// ```dart
/// // Configure cache globally at app startup (or disable by passing null)
/// ApiService.configureCache(cacheManager);
///
/// // Use from a feature service that extends ApiService
/// final resp = await get<User>('https://api.example.com/me', useCache: true);
/// final user = resp.body; // decoded by GetConnect decoder
/// ```
///
// ────────────────────────────────────────────────
class ApiService extends GetConnect {
  /// **_withAuthRetry**
  ///
  /// Execute a request and retry once after a 401 if [refreshSession] succeeds.
  ///
  /// **Parameters**
  /// - `run`: Closure that performs the request given up-to-date headers.
  ///
  /// **Returns**
  /// - `Response<T>`: Original or retried response.
  ///
  /// **Notes**
  /// - Builds headers for each attempt to include a newly refreshed token.
  ///
  // ────────────────────────────────────────────────
  Future<Response<T>> _withAuthRetry<T>(
    Future<Response<T>> Function(Map<String, String> headers) run,
  ) async {
    var resp = await run(getAuthorizedHeader());
    if (resp.statusCode == 401) {
      final refreshed = await refreshSession();
      if (refreshed) {
        resp = await run(getAuthorizedHeader());
      }
    }
    return resp;
  }

  // Global cache manager. If null, caching is disabled.
  static CacheManager? _cacheManager;

  /// **configureCache**
  ///
  /// Set or disable the global [CacheManager] used by all ApiService instances.
  /// When `manager` is `null`, caching is disabled and all cache paths no-op.
  ///
  /// **Parameters**
  /// - `manager`: Cache orchestrator; pass `null` to disable caching.
  ///
  /// **Side Effects**
  /// - Affects all subsequent requests made through ApiService subclasses.
  ///
  // ────────────────────────────────────────────────
  static void configureCache(CacheManager? manager) {
    _cacheManager = manager;
  }

  /// **accessToken**
  ///
  /// Current access token from [MemoryService], or `null` when not signed in.
  // ────────────────────────────────────────────────
  String? get accessToken => MemoryService.instance.accessToken;

  /// **refreshToken**
  ///
  /// Current refresh token from [MemoryService], or `null` when not available.
  // ────────────────────────────────────────────────
  String? get refreshToken => MemoryService.instance.refreshToken;

  /// Initializes the API service with a timeout setting for HTTP requests.
  /// **onInit**
  ///
  /// Configure default HTTP client settings.
  ///
  /// **Side Effects**
  /// - Sets the default request timeout to 120 seconds.
  ///
  // ────────────────────────────────────────────────
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 120);
    super.onInit();
  }

  /// Performs a cached HTTP GET request.
  @override
  Future<Response<T>> get<T>(
    String url, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    bool useCache = true,
    bool forceRefresh = false,
  }) async {
    // 1) Try cache via helper
    final cached = await _tryServeFromCache<T>(
      method: 'GET',
      url: url,
      useCache: useCache,
      forceRefresh: forceRefresh,
      query: query,
      headers: headers,
      decoder: decoder,
    );
    if (cached != null) return cached;

    // 2) Perform network request with auth-retry.
    final response = await _withAuthRetry<T>((authHeaders) async {
      final h = {...?headers, ...authHeaders};
      return await super.get(
        url,
        contentType: contentType,
        headers: h,
        query: query,
        decoder: decoder,
      );
    });

    // 3) Cache the response on success.
    if (!response.hasError) {
      await _tryWriteCache(
        method: 'GET',
        url: url,
        useCache: useCache,
        statusCode: response.statusCode,
        bodyString: response.bodyString,
        query: query,
        headers: headers,
      );
    }

    logRequestData(response);
    handleError(response);
    return response;
  }

  /// Performs a cached HTTP POST request.
  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
    bool useCache = false,
    bool forceRefresh = false,
  }) async {
    // 1) Try cache via helper (only if URL is not null)
    if (url != null) {
      final cached = await _tryServeFromCache<T>(
        method: 'POST',
        url: url,
        useCache: useCache,
        forceRefresh: forceRefresh,
        query: query,
        headers: headers,
        decoder: decoder,
      );
      if (cached != null) return cached;
    }

    // 2) Perform network request with auth-retry.
    final response = await _withAuthRetry<T>((authHeaders) async {
      final h = {...?headers, ...authHeaders};
      return await super.post(
        url,
        body,
        contentType: contentType,
        headers: h,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
    });

    // 3) Cache the response on success (only if URL is not null).
    if (!response.hasError && url != null) {
      await _tryWriteCache(
        method: 'POST',
        url: url,
        useCache: useCache,
        statusCode: response.statusCode,
        bodyString: response.bodyString,
        query: query,
        headers: headers,
      );
    }

    logRequestData(response, body);
    handleError(response);
    return response;
  }

  /// Performs a cached HTTP PUT request.
  @override
  Future<Response<T>> put<T>(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
    bool useCache = false,
    bool forceRefresh = false,
  }) async {
    // 1) Try cache via helper
    final cached = await _tryServeFromCache<T>(
      method: 'PUT',
      url: url,
      useCache: useCache,
      forceRefresh: forceRefresh,
      query: query,
      headers: headers,
      decoder: decoder,
    );
    if (cached != null) return cached;

    // 2) Perform network request with auth-retry.
    final response = await _withAuthRetry<T>((authHeaders) async {
      final h = {...?headers, ...authHeaders};
      return await super.put(
        url,
        body,
        contentType: contentType,
        headers: h,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
    });

    // 3) Cache the response on success.
    if (!response.hasError) {
      await _tryWriteCache(
        method: 'PUT',
        url: url,
        useCache: useCache,
        statusCode: response.statusCode,
        bodyString: response.bodyString,
        query: query,
        headers: headers,
      );
    }

    logRequestData(response, body);
    handleError(response);
    return response;
  }

  /// Performs a cached HTTP DELETE request.
  @override
  Future<Response<T>> delete<T>(
    String url, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    bool useCache = false,
    bool forceRefresh = false,
  }) async {
    // 1) Try cache via helper
    final cached = await _tryServeFromCache<T>(
      method: 'DELETE',
      url: url,
      useCache: useCache,
      forceRefresh: forceRefresh,
      query: query,
      headers: headers,
      decoder: decoder,
    );
    if (cached != null) return cached;

    // 2) Perform network request with auth-retry.
    final response = await _withAuthRetry<T>((authHeaders) async {
      final h = {...?headers, ...authHeaders};
      return await super.delete(
        url,
        contentType: contentType,
        headers: h,
        query: query,
        decoder: decoder,
      );
    });

    // 3) Cache the response on success.
    if (!response.hasError) {
      await _tryWriteCache(
        method: 'DELETE',
        url: url,
        useCache: useCache,
        statusCode: response.statusCode,
        bodyString: response.bodyString,
        query: query,
        headers: headers,
      );
    }

    logRequestData(response);
    handleError(response);
    return response;
  }

  /// Custom method to download a file from the given URL.
  ///
  /// [url]: The URL to download the file from.
  /// [fileName]: The name to save the file as.
  /// [onReceiveProgress]: Callback to track download progress.
  Future<File> downloadFile(
    String url,
    String fileName, {
    Map<String, String>? headers,
    Function(int received, int total)? onReceiveProgress,
  }) async {
    Directory tempDir = await getApplicationSupportDirectory();
    String savePath = '${tempDir.path}/$fileName';

    // Create the file to save the download
    File file = File(savePath);
    final request = await HttpClient().getUrl(Uri.parse(url));

    // Add headers if provided
    (headers ?? getAuthorizedHeader()).forEach((key, value) {
      request.headers.add(key, value);
    });

    final response = await request.close();

    if (response.statusCode == 200) {
      final total = response.contentLength;
      int received = 0;

      final sink = file.openWrite();
      await for (final chunk in response) {
        received += chunk.length;
        sink.add(chunk);
        if (onReceiveProgress != null) {
          onReceiveProgress(received, total);
        }
      }
      await sink.close();
      return file;
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  }

  /// Logs request and response data for debugging purposes.
  void logRequestData(Response response, [dynamic body]) {
    assert(() {
      final url = response.request?.url.toString();
      final headers = Map.of(response.request?.headers ?? {});
      if (headers.containsKey('Authorization')) {
        headers['Authorization'] = 'Bearer <redacted>';
      }
      debugPrint('Calling API: $url');
      debugPrint('Headers: $headers');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('body: ${body is String ? '<string>' : body}');
      final preview = response.bodyString;
      debugPrint('Response: ${preview != null && preview.length > 200 ? preview.substring(0, 200) : preview}');
      return true;
    }());
  }

  /// Handles errors in API responses. Maps to typed exceptions without throwing decode errors.
  void handleError(Response response) {
    if (!response.hasError) return;
    final status = response.statusCode ?? 0;
    final body = response.body;
    String? message;
    if (body is Map && body['message'] is String) {
      message = body['message'] as String;
    } else if (body is Map && body['detail'] is String) {
      message = body['detail'] as String;
    } else if (response.statusText != null) {
      message = response.statusText;
    }

    switch (status) {
      case 401:
        throw AuthException('Unauthorized');
      case 404:
        throw APIException(message ?? 'Not found');
      case 408:
        throw APIException('Request timeout');
      default:
        throw APIException(message ?? 'Unexpected error ($status)');
    }
  }

  /// Generates the default headers for API requests.
  Map<String, String> getAuthorizedHeader([String? token]) {
    final t = token ?? MemoryService.instance.accessToken;
    return {
      if (t != null && t.isNotEmpty) 'Authorization': 'Bearer $t',
      'content-type': 'application/json',
    };
  }

  /// Generates the headers for unauthorized requests.
  Map<String, String> getUnauthorizedHeader() {
    return {
      'content-type': 'application/json',
    };
  }

  /// Refreshes the session by renewing the access token using the refresh token.
  /// Returns true if successful; returns false if it fails. No navigation here.
  Future<bool> refreshSession() async {
    try {
      final rt = MemoryService.instance.refreshToken;
      if (rt == null || rt.isEmpty) return false;
      final body = {'refresh': rt};
      final Response response = await super.post(
        APIConfiguration.refreshSessionUrl,
        body,
        headers: getUnauthorizedHeader(),
      );
      if (response.hasError) return false;
      final access = (response.body is Map) ? (response.body['access'] as String?) : null;
      if (access == null || access.isEmpty) return false;
      MemoryService.instance.accessToken = access;
      return true;
    } catch (_) {
      // Clear tokens but don't navigate; let callers decide.
      MemoryService.instance.accessToken = null;
      MemoryService.instance.refreshToken = null;
      return false;
    }
  }

  // ===== Private helpers to reduce duplication across verbs =====

  /// **_decodeCachedPayload**
  ///
  /// Decode a cached raw string into a typed body `T` using the optional
  /// GetConnect `decoder` when provided. Attempts JSON first, then falls back
  /// to passing the raw string to the decoder or casting.
  ///
  /// **Parameters**
  /// - `cached`: Raw cached payload string.
  /// - `decoder`: Optional GetConnect decoder for `T`.
  ///
  /// **Returns**
  /// - `T`: Decoded value suitable for `Response<T>.body`.
  ///
  // ────────────────────────────────────────────────
  T _decodeCachedPayload<T>(String cached, Decoder<T>? decoder) {
    if (decoder != null) {
      try {
        final dynamic jsonObj = jsonDecode(cached);
        return decoder(jsonObj);
      } catch (_) {
        return decoder(cached);
      }
    }
    try {
      final dynamic jsonObj = jsonDecode(cached);
      return jsonObj as T;
    } catch (_) {
      return cached as T;
    }
  }

  /// **_tryServeFromCache**
  ///
  /// Attempt to serve a request from cache via the configured [CacheManager].
  /// Returns a synthesized `Response<T>` on a cache hit, or `null` to signal
  /// that the network should be used.
  ///
  /// **Parameters**
  /// - `method`: HTTP method used for keying and policy decisions.
  /// - `url`: Full request URL.
  /// - `useCache`: Caller intent to use cache for this request.
  /// - `forceRefresh`: Bypass cache read when true.
  /// - `query`: Optional query map for keying.
  /// - `headers`: Optional headers for keying (strategy-dependent).
  /// - `decoder`: Optional decoder to rehydrate cached string to `T`.
  ///
  /// **Returns**
  /// - `Future<Response<T>?>`: Cached response or `null`.
  ///
  // ────────────────────────────────────────────────
  Future<Response<T>?> _tryServeFromCache<T>({
    required String method,
    required String url,
    required bool useCache,
    required bool forceRefresh,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Decoder<T>? decoder,
  }) async {
    if (_cacheManager == null || !useCache) return null;
    final cachedString = await _cacheManager!.tryRead(
      method,
      url,
      query,
      forceRefresh: forceRefresh,
      headers: headers,
    );
    if (cachedString == null) return null;
    log('Serving from cache: $url');
    final decoded = _decodeCachedPayload<T>(cachedString, decoder);
    return Response<T>(body: decoded, statusCode: 200);
  }

  /// **_tryWriteCache**
  ///
  /// Attempt to write a response to cache through the configured [CacheManager]
  /// honoring the active cache policy.
  ///
  /// **Parameters**
  /// - `method`: HTTP method.
  /// - `url`: Full request URL.
  /// - `useCache`: Caller intent to cache this response.
  /// - `statusCode`: Response status used for write gating.
  /// - `bodyString`: Raw response text.
  /// - `query`: Optional query map.
  /// - `headers`: Optional headers for keying.
  ///
  /// **Side Effects**
  /// - Writes to underlying storage when permitted by policy.
  ///
  // ────────────────────────────────────────────────
  Future<void> _tryWriteCache({
    required String method,
    required String url,
    required bool useCache,
    required int? statusCode,
    String? bodyString,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    if (_cacheManager == null || !useCache) return;
    await _cacheManager!.tryWrite(
      method,
      url,
      query,
      statusCode: statusCode,
      bodyString: bodyString,
      headers: headers,
    );
  }
}
