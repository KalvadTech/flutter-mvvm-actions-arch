import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '/src/config/config.dart';

/// **FormValidators**
///
/// A collection of common form input validators with i18n support.
///
/// **Features**:
/// - Email, phone, password, name, and username validation
/// - Configurable regex patterns
/// - i18n error messages via GetX
/// - Easy to extend with custom validators
///
/// **Usage**:
/// ```dart
/// TextFormField(
///   validator: FormValidators.email,
/// )
/// ```
///
/// **Note**: Phone regex is configured for Saudi format (05xxxxxxxx).
/// Override `phoneRegex` for different regions.
class FormValidators {
  FormValidators._(); // Private constructor

  /// Regular expression for phone number validation.
  ///
  /// Default: Saudi format (05xxxxxxxx, 5xxxxxxxx, with optional separators)
  /// Override for different regions:
  /// ```dart
  /// FormValidators.phoneRegex = RegExp(r'^\+?1?\d{10}$'); // US format
  /// ```
  static RegExp phoneRegex = RegExp(r"^0?[5]{1}\d{1}[\- ]?\d{3}[\- ]?\d{4}$");

  /// Regular expression for email validation.
  ///
  /// Validates standard email format: name@domain.ext
  static RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",
  );

  /// Regular expression for password validation.
  ///
  /// Requirements:
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one numeric digit
  /// - At least one special character (!@#$&*~)
  /// - Minimum length: 8 characters
  static RegExp passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // Email Validation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validates an email address.
  ///
  /// Returns localized error message if invalid, otherwise null.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.email,
  /// )
  /// ```
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return tkEmailEmptyMsg.tr;
    } else if (!emailRegex.hasMatch(value)) {
      return tkEmailNotValidMsg.tr;
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Phone Validation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validates a phone number.
  ///
  /// Returns localized error message if invalid, otherwise null.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.phone,
  /// )
  /// ```
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return tkPhoneEmptyMsg.tr;
    } else if (!phoneRegex.hasMatch(value)) {
      return tkPhoneNotValidMsg.tr;
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Password Validation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validates a password.
  ///
  /// Returns localized error message if invalid, otherwise null.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.password,
  ///   obscureText: true,
  /// )
  /// ```
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return tkPasswordEmptyMsg.tr;
    } else if (!passwordRegex.hasMatch(value)) {
      return tkPasswordNotValidMsg.tr;
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Simple Validators
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validates a name field (non-empty check).
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.name,
  /// )
  /// ```
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return tkNameEmptyMsg.tr;
    }
    return null;
  }

  /// Validates a username (non-empty check).
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.username,
  /// )
  /// ```
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return tkUsernameMsg.tr;
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Generic Validators
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generic required field validator.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.required(value, 'Field is required'),
  /// )
  /// ```
  static String? required(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  /// Minimum length validator.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.minLength(value, 6, 'Min 6 chars'),
  /// )
  /// ```
  static String? minLength(String? value, int min, String errorMessage) {
    if (value == null || value.length < min) {
      return errorMessage;
    }
    return null;
  }

  /// Maximum length validator.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.maxLength(value, 20, 'Max 20 chars'),
  /// )
  /// ```
  static String? maxLength(String? value, int max, String errorMessage) {
    if (value != null && value.length > max) {
      return errorMessage;
    }
    return null;
  }

  /// Custom regex pattern validator.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.pattern(
  ///     value,
  ///     RegExp(r'^\d+$'),
  ///     'Only numbers allowed',
  ///   ),
  /// )
  /// ```
  static String? pattern(String? value, RegExp pattern, String errorMessage) {
    if (value == null || !pattern.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Combines multiple validators.
  ///
  /// Returns the first error found, or null if all pass.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.combine([
  ///     FormValidators.email,
  ///     (value) => FormValidators.minLength(value, 5, 'Too short'),
  ///   ]),
  /// )
  /// ```
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
