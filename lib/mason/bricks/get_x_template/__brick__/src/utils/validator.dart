import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '/src/config/config.dart';

/// A class to handle input validations such as phone numbers, emails, passwords, and usernames.
class InputsValidator {
  /// Regular expression to validate phone numbers.
  /// Works with the following formats:
  /// - 05xxxxxxxx
  /// - 05x-xxx-xxxx
  /// - 05x xxx xxxx
  /// - 5xxxxxxxx
  /// - 5x-xxx-xxxx
  /// - 5x xxx xxxx
  static final RegExp _phoneRegExp = RegExp(r"^0?[5]{1}\d{1}[\- ]?\d{3}[\- ]?\d{4}$");

  /// Regular expression to validate email addresses.
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
  );

  /// Regular expression to validate passwords.
  /// Ensures the password contains:
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one numeric digit
  /// - At least one special character
  /// - Minimum length of 8 characters
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  /// Validates a phone number.
  /// Returns a localized error message if the phone number is invalid or null, otherwise returns `null`.
  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tkPhoneEmptyMsg.tr;
    } else if (!_phoneRegExp.hasMatch(value)) {
      return tkPhoneNotValidMsg.tr;
    }
    return null;
  }

  /// Validates an email address.
  /// Returns a localized error message if the email is invalid or null, otherwise returns `null`.
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tkEmailEmptyMsg.tr;
    } else if (!_emailRegExp.hasMatch(value)) {
      return tkEmailNotValidMsg.tr;
    }
    return null;
  }

  /// Validates a password.
  /// Returns a localized error message if the password is invalid or null, otherwise returns `null`.
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tkPasswordEmptyMsg.tr;
    } else if (!_passwordRegExp.hasMatch(value)) {
      return tkPasswordNotValidMsg.tr;
    }
    return null;
  }

  /// Validates a name field.
  /// Returns a localized error message if the name is null or empty, otherwise returns `null`.
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tkNameEmptyMsg.tr;
    }
    return null;
  }

  /// Validates a username.
  /// Returns a localized error message if the username is null or empty, otherwise returns `null`.
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tkUsernameMsg.tr;
    }
    return null;
  }
}
