import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

/// **ApiStatus**
///
/// Lifecycle status for a single request.
// ────────────────────────────────────────────────
enum ApiStatus { idle, loading, success, error }

/// **ApiResponse**
///
/// Immutable request state container holding data or error and a status.
///
/// **Why**
/// - Prevent accidental mutations across widgets.
/// - Preserve original error type and stack for diagnostics.
///
/// **Key Features**
/// - `data`, `error`, `stackTrace`, and `status` are all final.
/// - Convenience factories for each lifecycle state.
/// - Readable property getters: `isLoading`, `hasData`, `hasError`.
///
/// **Example**
/// ```dart
/// final r = ApiResponse.success(user);
/// if (r.hasData) print(r.data!.name);
/// ```
///
// ────────────────────────────────────────────────
class ApiResponse<E> {
  const ApiResponse._({
    this.data,
    this.error,
    this.stackTrace,
    required this.status,
  });

  final E? data;
  final Object? error;
  final StackTrace? stackTrace;
  final ApiStatus status;

  factory ApiResponse.idle() => const ApiResponse._(status: ApiStatus.idle);
  factory ApiResponse.loading() => const ApiResponse._(status: ApiStatus.loading);
  factory ApiResponse.success(E data) => ApiResponse._(data: data, status: ApiStatus.success);
  factory ApiResponse.error(Object error, [StackTrace? st]) =>
      ApiResponse._(error: error, stackTrace: st, status: ApiStatus.error);

  bool get isLoading => status == ApiStatus.loading;
  bool get hasData => data != null;
  bool get hasError => error != null;
}

/// **apiFetch**
///
/// Emit a short-lived stream of request states: `loading? -> success | error`.
/// Executes the provided function inside the try/catch, capturing sync throws.
///
/// **Parameters**
/// - `run`: `Future<E> Function()` that performs the async operation.
/// - `withLoading`: When true, emits a loading state first (default true).
/// - `reportToSentry`: When true, forwards caught errors to Sentry (default true).
///
/// **Returns**
/// - `Stream<ApiResponse<E>>`: A stream that completes after emitting the terminal state.
///
/// **Notes**
/// - Prefer to avoid double-reporting errors if your infra already captures them.
///   Set `reportToSentry: false` here when infra captures errors.
///
/// **Example**
/// ```dart
/// apiFetch(() => service.loadUser()).listen((s) => state.value = s);
/// ```
///
// ────────────────────────────────────────────────
Stream<ApiResponse<E>> apiFetch<E>(
  Future<E> Function() run, {
  bool withLoading = true,
  bool reportToSentry = true,
}) async* {
  try {
    if (withLoading) yield ApiResponse<E>.loading();
    final data = await run();
    yield ApiResponse.success(data);
  } catch (e, st) {
    yield ApiResponse<E>.error(e, st);
    assert(() {
      debugPrint('Exception: $e');
      debugPrint('StackTrace: $st');
      return true;
    }());
    if (reportToSentry) {
      await Sentry.captureException(e, stackTrace: st);
    }
  }
}

/// **PaginationResponse**
///
/// Simple pagination envelope with total rows.
// ────────────────────────────────────────────────
class PaginationResponse<E> {
  const PaginationResponse(this.data, this.totalRows);
  final E data;
  final int totalRows;
}
