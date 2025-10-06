/// **LanguageModel**
///
/// Immutable data class representing a language option with its display name,
/// ISO language code, and associated country code.
///
/// **Why**
/// - Provide type-safe language representation for UI selection.
/// - Encapsulate language metadata (name, code, country) in a single model.
///
/// **Key Features**
/// - Immutable value object (all fields final).
/// - Const constructor for compile-time instantiation.
/// - Used in dropdown pickers and language selection UI.
///
/// **Example**
/// ```dart
/// const english = LanguageModel('English', 'en', 'GB');
/// const arabic = LanguageModel('العربية', 'ar', 'AE');
///
/// // Access properties
/// print(english.name); // 'English'
/// print(arabic.code); // 'ar'
/// ```
///
// ────────────────────────────────────────────────
class LanguageModel {
  /// The display name of the language (e.g., 'English', 'العربية').
  final String name;

  /// The ISO 639-1 language code (e.g., 'en', 'ar').
  final String code;

  /// The ISO 3166-1 alpha-2 country code (e.g., 'GB', 'AE').
  final String countryCode;

  /// Creates a [LanguageModel] with the given language metadata.
  ///
  /// **Parameters**
  /// - `name`: Human-readable language name
  /// - `code`: Two-letter ISO 639-1 language code
  /// - `countryCode`: Two-letter ISO 3166-1 country code
  const LanguageModel(this.name, this.code, this.countryCode);
}
