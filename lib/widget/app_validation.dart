
// lib/utils/app_validators.dart
import 'package:flutter/material.dart';

/// Alias matches Flutter's FormFieldValidator signature.
typedef Validator = String? Function(String? value);

/// Centralized, reusable validators for the app.
class AppValidators {
  // --------------------------
  // Combinators
  // --------------------------
  /// Combines multiple validators; returns the first error, or null if all pass.
  static Validator combine(List<Validator> validators) {
    return (String? value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // --------------------------
  // Generic
  // --------------------------
  static Validator required({String message = 'This field cannot be empty'}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  static Validator minLength(int min, {String? message}) {
    return (String? value) {
      if ((value ?? '').length < min) {
        return message ?? 'Must be at least $min characters';
      }
      return null;
    };
  }

  static Validator maxLength(int max, {String? message}) {
    return (String? value) {
      if ((value ?? '').length > max) {
        return message ?? 'Must be at most $max characters';
      }
      return null;
    };
  }

  static Validator pattern(RegExp regex, {required String message}) {
    return (String? value) {
      if (value == null || !regex.hasMatch(value)) return message;
      return null;
    };
  }

  /// Validates exact length (useful for OTP/pin).
  static Validator exactLength(int len, {String? message}) {
    return (String? value) {
      if ((value ?? '').length != len) {
        return message ?? 'Must be exactly $len characters';
      }
      return null;
    };
  }

  // --------------------------
  // Specialized text
  // --------------------------
  static Validator email({String message = 'Enter a valid email address'}) {
    // RFC 5322-ish practical regex (conservative for apps)
    final regex = RegExp(r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$');
    return pattern(regex, message: message);
  }

  static Validator phone({
    String message = 'Enter a valid phone number',
    RegExp? regex,
  }) {
    // Default: international format, digits with optional + and separators.
    final defaultRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return pattern(regex ?? defaultRegex, message: message);
  }

  static Validator url({
    String message = 'Enter a valid URL',
    RegExp? regex,
  }) {
    final defaultRegex = RegExp(
      r'^(https?:\/\/)?' // optional http/https
      r'([A-Za-z0-9\-]+\.)+[A-Za-z]{2,}' // domain
      r'(:\d+)?(\/\S*)?$', // optional port + path
    );
    return pattern(regex ?? defaultRegex, message: message);
  }

  static Validator username({
    String message = 'Enter a valid username',
    int min = 3,
    int max = 20,
    RegExp? regex,
  }) {
    // Letters, numbers, underscore, dot; starts with letter/number.
    final defaultRegex = RegExp(r'^[A-Za-z0-9](?:[A-Za-z0-9._]{1,})$');
    return combine([
      minLength(min, message: 'Must be at least $min characters'),
      maxLength(max, message: 'Must be at most $max characters'),
      pattern(regex ?? defaultRegex, message: message),
    ]);
  }

  static Validator otp({
    int length = 6,
    String message = 'Enter a valid OTP',
  }) {
    final regex = RegExp(r'^[0-9]+$');
    return combine([
      exactLength(length, message: 'OTP must be $length digits'),
      pattern(regex, message: message),
    ]);
  }

  // --------------------------
  // Numeric
  // --------------------------
  static Validator number({
    String message = 'Enter a valid number',
  }) {
    return (String? value) {
      if (value == null) return message;
      final v = value.trim();
      if (v.isEmpty) return message;
      final parsed = num.tryParse(v);
      if (parsed == null) return message;
      return null;
    };
  }

  static Validator numberRange({
    num? min,
    num? max,
    String? minMessage,
    String? maxMessage,
    String parseMessage = 'Enter a valid number',
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return parseMessage;
      final parsed = num.tryParse(value.trim());
      if (parsed == null) return parseMessage;
      if (min != null && parsed < min) {
        return minMessage ?? 'Must be ≥ $min';
      }
      if (max != null && parsed > max) {
        return maxMessage ?? 'Must be ≤ $max';
      }
      return null;
    };
  }

  // --------------------------
  // Dates
  // --------------------------
  /// Validates an ISO-like date string (yyyy-mm-dd) format.
  static Validator isoDate({
    String message = 'Enter date as YYYY-MM-DD',
  }) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return pattern(regex, message: message);
  }

  /// Compares two date strings (yyyy-mm-dd). Provide suppliers for values.
  static Validator dateOrder({
    required String Function() startSupplier,
    required String Function() endSupplier,
    String parseMessage = 'Enter date as YYYY-MM-DD',
    String orderMessage = 'End date must be after start date',
  }) {
    DateTime? _parse(String s) {
      try {
        final parts = s.split('-');
        if (parts.length != 3) return null;
        final y = int.parse(parts[0]);
        final m = int.parse(parts[1]);
        final d = int.parse(parts[2]);
        return DateTime(y, m, d);
      } catch (_) {
        return null;
      }
    }

    return (String? _) {
      final startStr = startSupplier();
      final endStr = endSupplier();
      final start = _parse(startStr);
      final end = _parse(endStr);
      if (start == null || end == null) return parseMessage;
      if (!end.isAfter(start) && !end.isAtSameMomentAs(start)) {
        return orderMessage;
      }
      return null;
    };
  }

  // --------------------------
  // Equality checks
  // --------------------------
  static Validator equalsTo({
    required String Function() otherSupplier,
    String emptyMessage = 'This field cannot be empty',
    String mismatchMessage = 'Values do not match',
  }) {
    return (String? value) {
      final current = value ?? '';
      if (current.isEmpty) return emptyMessage;
      if (current != otherSupplier()) return mismatchMessage;
      return null;
    };
  }

  static Validator notEqualsTo({
    required String Function() otherSupplier,
    String emptyMessage = 'This field cannot be empty',
    String message = 'Value must be different',
  }) {
    return (String? value) {
      final current = value ?? '';
      if (current.isEmpty) return emptyMessage;
      if (current == otherSupplier()) return message;
      return null;
    };
  }

  // --------------------------
  // Passwords
  // --------------------------
  /// Configurable password validator suitable for production apps.
  static Validator password({
    int min = 6,
    int? max,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumber = true,
    bool requireSpecial = true,
    String requiredMessage = 'Password cannot be empty',
    String? minMessage,
    String? maxMessage,
    String uppercaseMessage = 'Must contain at least one uppercase letter',
    String lowercaseMessage = 'Must contain at least one lowercase letter',
    String numberMessage = 'Must contain at least one number',
    String specialMessage = 'Must contain at least one special character',
  }) {
    final validators = <Validator>[
      required(message: requiredMessage),
      minLength(min, message: minMessage ?? 'Password must be at least $min characters'),
    ];
    if (max != null) {
      validators.add(maxLength(max, message: maxMessage ?? 'Password must be at most $max characters'));
    }
    if (requireUppercase) validators.add(pattern(RegExp(r'[A-Z]'), message: uppercaseMessage));
    if (requireLowercase) validators.add(pattern(RegExp(r'[a-z]'), message: lowercaseMessage));
    if (requireNumber) validators.add(pattern(RegExp(r'[0-9]'), message: numberMessage));
    if (requireSpecial) {




      validators.add(
          pattern(
            RegExp(r'[!@#\$%\^&*(),.?":{}|<>_\-\\/\[\];\''~+=]'),
              message: specialMessage,
            ),
          );




      }
          return combine(validators);
    }

  /// Confirm password validator that compares two fields.
  static Validator confirmPassword({
    required String Function() passwordSupplier,
    String emptyMessage = 'Confirm password cannot be empty',
    String mismatchMessage = 'Passwords do not match',
  }) {
    return (String? value) {
      final confirm = value ?? '';
      if (confirm.isEmpty) return emptyMessage;
      final original = passwordSupplier();
      if (confirm != original) return mismatchMessage;
      return null;
    };
  }
}
