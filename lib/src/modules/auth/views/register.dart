import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/utils/form_validators.dart';
import '/src/utils/responsive_utils.dart';
import '/src/core/routing/route_manager.dart';
import '/src/presentation/custom/customs.dart';
import '/src/modules/auth/auth.dart';

/// **RegisterPage**
///
/// Modern registration form with Material 3 design using FloatSurfaceCard for
/// visual elevation and consistency with the rest of the app.
///
/// **Why**
/// - Keep form validation and field wiring in the view while business flow
///   lives in actions/view model
/// - Use FloatSurfaceCard for consistency with login and other pages
/// - Responsive design adapts to different screen sizes
///
/// **Features**
/// - AppBar with back button for navigation
/// - SingleChildScrollView prevents keyboard overflow issues
/// - FloatSurfaceCard wraps form for visual elevation
/// - Responsive padding using ResponsiveUtils
/// - Form validation with GlobalKey
/// - Password field properly obscured
/// - Better spacing and visual hierarchy
///
/// **Side Effects**
/// - Fields save into [AuthViewModel.newUser] via onSaved callbacks
/// - On submit, triggers [AuthActions.signUp] which shows loader and error handling
///
/// **Usage**
/// ```dart
/// // Navigated to from LoginPage via AuthActions.toRegisterPage()
/// const RegisterPage()
/// ```
///
/// // ────────────────────────────────────────────────
class RegisterPage extends GetWidget<AuthViewModel> {
  const RegisterPage({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(tkRegisterPage),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => RouteManager.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.valueByDevice(
            context,
            mobile: const EdgeInsets.all(16.0),
            tablet: const EdgeInsets.all(24.0),
            desktop: const EdgeInsets.all(32.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo (smaller size since more fields)
                SvgPicture.asset(
                  AssetsManager.logoPath,
                  height: MediaQuery.of(context).size.height / 8,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                // Registration form wrapped in FloatSurfaceCard
                FloatSurfaceCard(
                  size: FSCSize.standard,
                  elevation: FSCElevation.resting,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Page Title
                      const CustomText(
                        tkCreateAccount,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Username Field
                      CustomFormField(
                        label: tkUsername,
                        onSaved: (value) => controller.newUser.username = value,
                        maxLines: 1,
                        validator: FormValidators.username,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Phone Field
                      CustomFormField(
                        label: tkPhone,
                        onSaved: (value) => controller.newUser.phone = value,
                        maxLines: 1,
                        validator: FormValidators.phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      CustomFormField(
                        label: tkEmail,
                        onSaved: (value) => controller.newUser.email = value,
                        maxLines: 1,
                        validator: FormValidators.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Password Field (properly obscured)
                      PasswordFormField(
                        label: tkPassword,
                        onSaved: (value) => controller.newUser.password = value,
                        maxLines: 1,
                        validator: FormValidators.password,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 24),

                      // Register Button
                      CustomButton(
                        text: tkRegisterBtn,
                        onPressed: () => _register(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Footer (Already have account + Login)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(tkAlreadyHaveAccount),
                    TextButton(
                      onPressed: () => RouteManager.back(),
                      child: const CustomText(
                        tkLoginNow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **_register**
  ///
  /// Validates and saves the form, then triggers [AuthActions.signUp].
  ///
  /// **Parameters**
  /// - `context`: Build context used by the action presenter for overlay/snackbar.
  ///
  /// **Side Effects**
  /// - Updates [AuthViewModel.newUser] fields via `onSaved`.
  /// - Triggers the global loader overlay and error handling via [AuthActions].
  ///
  /// // ────────────────────────────────────────────────
  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthActions.instance.signUp(context);
    }
  }
}
