/// Authentication providers using Provider package
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/user.dart';
import 'package:itpapp/shared/models/auth_response.dart';
import 'package:itpapp/core/storage/local_storage_service.dart';
import 'package:itpapp/core/storage/storage_keys.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

// Local storage provider
final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Authentication state notifier
class AuthNotifier extends StateNotifier<User?> {
  final Ref ref;

  AuthNotifier(this.ref) : super(null) {
    _init();
  }

  Future<void> _init() async {
    await ref.read(localStorageProvider).init();
    _loadStoredUser();
  }

  void _loadStoredUser() {
    final storage = ref.read(localStorageProvider);
    final email = storage.getString(StorageKeys.userEmail);
    if (email != null) {
      //User might be already logged in, try to load from cache
    }
  }

  /// Login with email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await MockApiService.login(email: email, password: password);

      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.success && authResponse.user != null) {
        final user = User.fromJson(authResponse.user!);
        final storage = ref.read(localStorageProvider);

        // Save tokens and user data
        if (authResponse.accessToken != null) {
          await storage.saveString(StorageKeys.accessToken, authResponse.accessToken!);
        }
        if (authResponse.refreshToken != null) {
          await storage.saveString(StorageKeys.refreshToken, authResponse.refreshToken!);
        }
        await storage.saveString(StorageKeys.userEmail, user.email);

        state = user;
        return authResponse;
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(success: false, message: 'Login failed: $e');
    }
  }

  /// Social login (Microsoft or Google)
  Future<AuthResponse> socialLogin(String provider, String email) async {
    try {
      final response = await MockApiService.socialLogin(provider: provider, email: email);

      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.success && authResponse.user != null) {
        final user = User.fromJson(authResponse.user!);
        final storage = ref.read(localStorageProvider);

        if (authResponse.accessToken != null) {
          await storage.saveString(StorageKeys.accessToken, authResponse.accessToken!);
        }
        if (authResponse.refreshToken != null) {
          await storage.saveString(StorageKeys.refreshToken, authResponse.refreshToken!);
        }
        await storage.saveString(StorageKeys.userEmail, user.email);

        state = user;
        return authResponse;
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(success: false, message: 'Social login failed: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await MockApiService.logout();
      final storage = ref.read(localStorageProvider);

      // Clear auth data
      await storage.remove(StorageKeys.accessToken);
      await storage.remove(StorageKeys.refreshToken);
      await storage.remove(StorageKeys.userEmail);

      state = null;
    } catch (e) {
      state = null;
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => state != null;
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref);
});
