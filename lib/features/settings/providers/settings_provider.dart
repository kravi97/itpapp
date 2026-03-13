/// Settings/Profile providers
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/user_profile.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

/// Get user profile
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final response = await MockApiService.getUserProfile();

  if (response['success'] == true && response['data'] != null) {
    return UserProfile.fromJson(response['data']['profile'] as Map<String, dynamic>);
  }

  return null;
});

/// Manage profile updates
class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  ProfileNotifier() : super(const AsyncValue.data(null));

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.updateProfile(profile);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          Exception('Failed to update profile'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.changePassword(oldPassword, newPassword);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          Exception('Failed to change password'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<void>>((ref) {
  return ProfileNotifier();
});

/// App preferences/settings
class AppSettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  AppSettingsNotifier()
      : super({
          'themeMode': 'light',
          'notificationsEnabled': true,
          'emailNotifications': true,
          'pushNotifications': false,
          'language': 'en',
          'timeFormat': '24h',
        });

  void updateSetting(String key, dynamic value) {
    state = {...state, key: value};
  }

  void updateMultipleSettings(Map<String, dynamic> settings) {
    state = {...state, ...settings};
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, Map<String, dynamic>>((ref) {
  return AppSettingsNotifier();
});
