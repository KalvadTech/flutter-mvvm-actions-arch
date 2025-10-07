import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/presentation/custom/customs.dart';
import '/src/config/config.dart';
import '/src/utils/validator.dart';
import '/src/modules/auth/auth.dart';

/// **LoginPage**
///
/// Username/password form that validates input and delegates sign-in to
/// [AuthActions] upon submit.
/// 
/// **Why**
/// - Keep validation at the view level and business flow in actions/view model.
///
/// **Side Effects**
/// - On submit, saves form fields into [AuthViewModel] and triggers the action
///   handler which shows a loader overlay and error feedback.
///
/// **Usage**
/// ```dart
/// // Presented by AuthHandler when not authenticated
/// LoginPage()
/// ```
///
/// Notes
/// - Ensure password field is obscured in the underlying [CustomFormField].
///
/// // ────────────────────────────────────────────────
class LoginPage extends GetWidget<AuthViewModel> {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(
                  AssetsManager.logoPath,
                  height: MediaQuery.of(context).size.height / 4,
                  fit: BoxFit.contain,
                ),
                const CustomText(tkLoginPage),
                CustomFormField(
                  label: tkUsername,
                  onSaved: (value) => controller.username = value,
                  validator: InputsValidator.usernameValidator,
                ),
                CustomFormField(
                  label: tkPassword,
                  onSaved: (value) => controller.password = value,
                  validator: InputsValidator.passwordValidator,
                ),
                CustomButton(text: tkLoginBtn, onPressed: () => _login(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CustomText('You don\'t have account?'),
                    TextButton(
                      onPressed: AuthActions.instance.toRegisterPage,
                      child: const CustomText('Register Now'),
                    )
                  ],
                )
              ],
            ),
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
