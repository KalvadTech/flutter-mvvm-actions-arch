import 'package:flutter/material.dart';
import '../../core/presentation/api_response.dart';

/// **ApiHandler**
///
/// Minimal UI helper that renders loading/success/error states from an
/// `ApiResponse<E>`. Callers pass a `successBuilder` that receives data, and
/// may override the default loading widget; an error builder can customize
/// failure UI and use `tryAgain`.
///
/// **Why**
/// - Keep usage straightforward: only success needs data; loading/empty can be
///   composed as plain widgets by the caller.
///
/// **Key Features**
/// - Default spinner for loading (override with `loadingWidget`).
/// - Customizable error UI via `errorBuilder` and optional `tryAgain`.
/// - Data-aware `successBuilder(E data)`.
///
/// **Example**
/// ```dart
/// final r = controller.grades;
/// return ApiHandler<List<GradeModel>>(
///   response: r,
///   loadingWidget: const Center(child: CircularProgressIndicator()),
///   successBuilder: (grades) {
///     if (grades.isEmpty) return const Center(child: Text('No grades'));
///     return GradesList(grades: grades);
///   },
///   errorBuilder: (err, retry) => ErrorView(error: err, onRetry: retry),
///   tryAgain: controller.refreshData,
/// );
/// ```
///
// ────────────────────────────────────────────────
class ApiHandler<E> extends StatelessWidget {
  const ApiHandler({
    super.key,
    required this.response,
    required this.successBuilder,
    this.loadingWidget,
    this.errorBuilder,
    this.tryAgain,
    this.isEmpty,
    this.emptyWidget,
  });

  final ApiResponse<E> response;
  final Widget Function(E data) successBuilder;
  final Widget? loadingWidget;
  final Widget Function(Object error, VoidCallback? tryAgain)? errorBuilder;
  final VoidCallback? tryAgain;

  // Optional empty-state support
  final bool Function(E data)? isEmpty;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    switch (response.status) {
      case ApiStatus.idle:
        return const SizedBox.shrink();
      case ApiStatus.loading:
        return loadingWidget ?? const Center(child: CircularProgressIndicator());
      case ApiStatus.success:
        assert(response.data != null,
        'ApiResponse.success was used with null data. Ensure non-null data or handle nulls.');
        final data = response.data as E; // safe by contract above
        if (isEmpty != null && isEmpty!(data)) {
          return emptyWidget ?? const SizedBox.shrink();
        }
        return successBuilder(data);
      case ApiStatus.error:
        final err = response.error ?? Exception('Unknown error');
        if (errorBuilder != null) return errorBuilder!(err, tryAgain);
        return _DefaultErrorWidget(error: err, tryAgain: tryAgain);
    }
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.error, this.tryAgain});
  final Object error;
  final VoidCallback? tryAgain;

  @override
  Widget build(BuildContext context) {
    final msg = error is Exception ? error.toString() : '$error';
    return Center(
      child: InkWell(
        onTap: tryAgain,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(msg),
        ),
      ),
    );
  }
}