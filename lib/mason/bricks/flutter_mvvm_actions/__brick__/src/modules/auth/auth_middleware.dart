import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/core/routing/route_manager.dart';
import 'auth.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;
  bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    isAuthenticated = Get.find<AuthViewModel>().isAuthenticated();
    log('isAuthenticated: $isAuthenticated');
    if (isAuthenticated == false) {
      return RouteSettings(name: RouteManager.initialRoute);
    }
    return null;
  }
}