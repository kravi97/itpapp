/// Mock authentication data for development and testing
class AuthMockData {
  /// Mock user credentials for testing
  static const Map<String, String> validCredentials = {
    'john.doe@company.com': 'password123',
    'jane.smith@company.com': 'securePassword456',
    'test@example.com': 'test123',
  };

  /// Mock user profile data returned after successful login
  static const Map<String, dynamic> mockUserProfile = {
    'userId': 'USR-001',
    'email': 'john.doe@company.com',
    'name': 'John Doe',
    'employeeId': 'EMP-12345',
    'department': 'Engineering',
    'designation': 'Senior Software Engineer',
    'profilePicture': 'https://via.placeholder.com/150',
    'phone': '+1-555-123-4567',
    'createdAt': '2024-01-15T10:30:00Z',
    'lastLogin': '2026-03-13T09:00:00Z',
  };

  /// Mock authentication response
  static Map<String, dynamic> mockAuthResponse({
    required String email,
    required String accessToken,
    required String refreshToken,
  }) {
    return {
      'success': true,
      'message': 'Authentication successful',
      'data': {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'user': {
          ...mockUserProfile,
          'email': email,
        }
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Mock password reset response
  static const Map<String, dynamic> mockPasswordResetResponse = {
    'success': true,
    'message': 'Password reset link sent to your email',
    'data': {
      'resetTokenExpiry': '24h',
      'sentTo': 'john.doe@company.com',
    },
  };

  /// Mock error response for invalid credentials
  static const Map<String, dynamic> mockInvalidCredentialsError = {
    'success': false,
    'message': 'Invalid email or password',
    'errorCode': 'INVALID_CREDENTIALS',
    'statusCode': 401,
  };

  /// Mock social login response
  static Map<String, dynamic> mockSocialLoginResponse({
    required String provider,
    required String email,
  }) {
    return {
      'success': true,
      'message': '$provider login successful',
      'data': {
        'accessToken': 'mock_access_token_${provider}_${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock_refresh_token_${provider}_${DateTime.now().millisecondsSinceEpoch}',
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'isNewUser': false,
        'user': {
          ...mockUserProfile,
          'email': email,
          'loginProvider': provider,
        }
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
