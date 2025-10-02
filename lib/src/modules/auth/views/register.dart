import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/src/config/config.dart';
import '/src/utils/validator.dart';
import '/src/presentation/custom/customs.dart';
import '/src/modules/auth/auth.dart';

class RegisterPage extends GetWidget<AuthViewModel> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              AssetsManager.logoPath,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.contain,
            ),
            const CustomText(tkRegisterPage),
            CustomFormField(
              label: tkUsername,
              onSaved: (value) => controller.newUser.username = value,
              validator: InputsValidator.usernameValidator,
            ),
            CustomFormField(
              label: tkPhone,
              onSaved: (value) => controller.newUser.phone = value,
              validator: InputsValidator.phoneValidator,
            ),
            CustomFormField(
              label: tkEmail,
              onSaved: (value) => controller.newUser.email = value,
              validator: InputsValidator.emailValidator,
            ),
            CustomFormField(
              label: tkPassword,
              onSaved: (value) => controller.newUser.password = value,
              validator: InputsValidator.passwordValidator,
            ),
            CustomButton(
              text: tkRegisterBtn,
              onPressed: () => login(context),
            )
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) {
    AuthActions.instance.signUp(context);
  }
}
