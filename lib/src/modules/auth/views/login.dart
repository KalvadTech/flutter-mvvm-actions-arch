import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/presentation/custom/customs.dart';
import '/src/config/config.dart';
import '/src/utils/form_validators.dart';
import '/src/utils/responsive_utils.dart';
import '/src/modules/auth/auth.dart';

/// **LoginPage**
///
/// Modern login form with Material 3 design using FloatSurfaceCard for visual
/// elevation and consistency with the rest of the app.
///
/// **Why**
/// - Keep validation at the view level and business flow in actions/view model
/// - Use FloatSurfaceCard for consistency with posts and other pages
/// - Responsive design adapts to different screen sizes
///
/// **Features**
/// - AppBar for consistency with other pages
/// - SingleChildScrollView prevents keyboard overflow issues
/// - FloatSurfaceCard wraps form for visual elevation
/// - Responsive padding using ResponsiveUtils
/// - Better spacing and visual hierarchy
///
/// **Side Effects**
/// - On submit, saves form fields into [AuthViewModel] and triggers the action
///   handler which shows a loader overlay and error feedback
///
/// **Usage**
/// ```dart
/// // Presented by AuthHandler when not authenticated
/// LoginPage()
/// ```
///
/// // ────────────────────────────────────────────────
class LoginPage extends GetWidget<AuthViewModel> {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.valueByDevice(
            context,
            mobile: const EdgeInsets.all(16.0),
            tablet: const EdgeInsets.all(24.0),
            desktop: const EdgeInsets.all(32.0),
          ),
          child: Column(
            children: [
              // Logo (reduced size for better proportions)
              SvgPicture.asset(
                AssetsManager.logoPath,
                height: MediaQuery.of(context).size.height / 6,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 32),

              // Login form wrapped in FloatSurfaceCard
              FloatSurfaceCard(
                size: FSCSize.standard,
                elevation: FSCElevation.resting,
                body: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Page Title
                      const CustomText(
                        tkLoginPage,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Username Field
                      CustomFormField(
                        label: tkUsername,
                        onSaved: (value) => controller.username = value,
                        maxLines: 1,
                        validator: FormValidators.username,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      PasswordFormField(
                        label: tkPassword,
                        onSaved: (value) => controller.password = value,
                        maxLines: 1,
                        validator: FormValidators.password,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      CustomButton(
                        text: tkLoginBtn,
                        onPressed: () => _login(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Footer (Don't have account + Register)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(tkDontHaveAccount),
                  TextButton(
                    onPressed: AuthActions.instance.toRegisterPage,
                    child: const CustomText(
                      tkRegisterNow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **_login**
  ///
  /// Validates and saves the form, then triggers [AuthActions.signIn].
  ///
  /// **Parameters**
  /// - `context`: Build context used by the action presenter for overlay/snackbar.
  ///
  /// **Side Effects**
  /// - Updates [AuthViewModel.username] and [AuthViewModel.password] via `onSaved`.
  /// - Triggers the global loader overlay and error handling via [AuthActions].
  ///
  /// // ────────────────────────────────────────────────
  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthActions.instance.signIn(context);
    }
  }
}
