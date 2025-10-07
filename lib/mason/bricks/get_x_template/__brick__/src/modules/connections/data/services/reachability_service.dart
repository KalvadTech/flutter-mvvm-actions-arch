import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';

/// Strategy for reachability probing.
enum ReachabilityStrategy { dnsLookup, httpHead }

/// **ReachabilityService**
///
/// Lightweight, injectable service to determine internet reachability.
///
/// Why
/// - Abstracts the probing strategy (DNS vs. HTTP) and allows configurable host/timeout.
/// - Keeps ConnectionViewModel simple and focused on state transitions.
///
/// Parameters
/// - `host`: DNS host to resolve when using [ReachabilityStrategy.dnsLookup]. Defaults to `google.com`.
/// - `timeout`: Timeout applied to probes. Defaults to 3 seconds.
/// - `strategy`: Probe strategy (DNS lookup or HTTP HEAD/GET to a health endpoint). Defaults to DNS.
/// - `healthEndpoint`: Endpoint used when [strategy] is HTTP-based.
/// - `http`: Optional GetConnect instance for HTTP probing.
///
/// Returns
/// - `Future<bool>` indicating whether internet appears reachable.
///
/// Notes
/// - On Web, DNS sockets aren’t available; we optimistically return true here to avoid false negatives.
class ReachabilityService {
  ReachabilityService({
    this.host = 'google.com',
    this.timeout = const Duration(seconds: 3),
    this.strategy = ReachabilityStrategy.dnsLookup,
    this.healthEndpoint,
    GetConnect? http,
  }) : _http = http ?? GetConnect();

  final String host;
  final Duration timeout;
  final ReachabilityStrategy strategy;
  final Uri? healthEndpoint;
  final GetConnect _http;

  /// Returns true when internet appears reachable.
  Future<bool> isReachable() async {
    if (kIsWeb) {
      // On web we can't perform DNS lookups; returning true avoids showing false negatives.
      return true;
    }
    switch (strategy) {
      case ReachabilityStrategy.dnsLookup:
        try {
          final res = await InternetAddress.lookup(host).timeout(timeout);
          return res.isNotEmpty;
        } catch (_) {
          return false;
        }
      case ReachabilityStrategy.httpHead:
        final ep = healthEndpoint;
        if (ep == null) return false;
        try {
          // Try HEAD first; some backends may reject it, so we fallback to GET on 405.
          final resp = await _http
              .request(ep.toString(), 'HEAD', headers: const {})
              .timeout(timeout);
          final code = resp.statusCode ?? 0;
          if (code >= 200 && code < 300) return true;
          if (code == 405) {
            final getResp = await _http.get(ep.toString()).timeout(timeout);
            final getCode = getResp.statusCode ?? 0;
            return getCode >= 200 && getCode < 300;
          }
          return false;
        } catch (_) {
          return false;
        }
    }
  }
}
