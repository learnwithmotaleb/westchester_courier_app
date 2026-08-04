import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:westchester/helper/local_db/shareprefs_helper.dart';

import '../../core/enums/app_role.dart';
import '../../core/enums/post_category_type.dart';

class SharePrefsHelper {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================= POST CATEGORY =================

  static Future<void> savePostCategory(PostCategoryType type) async {
    await _prefs?.setString(SharePrefsKeys.postCategory, type.name);
  }

  static PostCategoryType? getPostCategory() {
    final value = _prefs?.getString(SharePrefsKeys.postCategory);
    if (value == null) return null;

    return PostCategoryType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PostCategoryType.move,
    );
  }

  static Future<void> clearPostCategory() async {
    await _prefs?.remove(SharePrefsKeys.postCategory);
  }

  // ================= GENERIC BOOL =================

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // ================= ROLE =================

  static Future<void> saveRole(AppRole role) async {
    await _prefs?.setString(SharePrefsKeys.role, role.name);
  }

  static AppRole? getRole() {
    final value = _prefs?.getString(SharePrefsKeys.role);
    if (value == null) return null;

    return AppRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppRole.CUSTOMER,
    );
  }

  static Future<void> clearRole() async {
    await _prefs?.remove(SharePrefsKeys.role);
  }

  // ================= TOKEN =================

  static Future<void> saveToken(String token) async {
    await _prefs?.setString(SharePrefsKeys.token, token);
  }

  static String? getToken() {
    return _prefs?.getString(SharePrefsKeys.token);
  }

  // ================= REFRESH TOKEN =================

  static Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString(SharePrefsKeys.refreshToken, token);
  }

  static String? getRefreshToken() {
    return _prefs?.getString(SharePrefsKeys.refreshToken);
  }

  // ================= USER ID =================

  static Future<void> saveUserId(String id) async {
    await _prefs?.setString(SharePrefsKeys.userId, id);
  }

  static String? getUserId() {
    return _prefs?.getString(SharePrefsKeys.userId);
  }

  // ================= PROFILE ID =================

  static Future<void> saveProfileId(String profileId) async {
    await _prefs?.setString(SharePrefsKeys.profileId, profileId);
  }

  static String? getProfileId() {
    return _prefs?.getString(SharePrefsKeys.profileId);
  }

  // ================= ONBOARD =================

  static Future<void> setOnboardSeen(bool value) async {
    await _prefs?.setBool(SharePrefsKeys.onboardSeen, value);
  }

  static bool getOnboardSeen() {
    return _prefs?.getBool(SharePrefsKeys.onboardSeen) ?? false;
  }

  // ================= THEME =================

  static ThemeMode getThemeMode() {
    switch (_prefs?.getString(SharePrefsKeys.themeMode)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';

    await _prefs?.setString(SharePrefsKeys.themeMode, value);
  }

  // ================= USER DATA =================

  static Future<void> saveUserData(String userDataJson) async {
    await _prefs?.setString(SharePrefsKeys.userData, userDataJson);
  }

  static String? getUserData() {
    return _prefs?.getString(SharePrefsKeys.userData);
  }

  // ================= CLEAR ALL =================

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // ================= USER SESSION (Login response) =================

  /// Saves all fields from the login `user` object in one call.
  static Future<void> saveUserSession({
    required String userId,
    required String email,
    required String role,
    required bool isProfileCompleted,
    required bool isApproved,
    required String approvalStatus,
  }) async {
    await _prefs?.setString(SharePrefsKeys.userId, userId);
    await _prefs?.setString(SharePrefsKeys.userEmail, email);
    await _prefs?.setString(SharePrefsKeys.userRole, role);
    await _prefs?.setBool(SharePrefsKeys.isProfileCompleted, isProfileCompleted);
    await _prefs?.setBool(SharePrefsKeys.isApproved, isApproved);
    await _prefs?.setString(SharePrefsKeys.approvalStatus, approvalStatus);
  }

  static String? getUserEmail() =>
      _prefs?.getString(SharePrefsKeys.userEmail);

  static String? getUserRole() =>
      _prefs?.getString(SharePrefsKeys.userRole);

  static bool getIsProfileCompleted() =>
      _prefs?.getBool(SharePrefsKeys.isProfileCompleted) ?? false;

  static bool getIsApproved() =>
      _prefs?.getBool(SharePrefsKeys.isApproved) ?? false;

  static String? getApprovalStatus() =>
      _prefs?.getString(SharePrefsKeys.approvalStatus);
}

