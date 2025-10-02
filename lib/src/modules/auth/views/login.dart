import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/presentation/custom/customs.dart';
import '/src/config/config.dart';
import '/src/utils/validator.dart';
import '/src/modules/auth/auth.dart';

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

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthActions.instance.signIn(context);
    }
  }
}
