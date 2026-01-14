import 'package:delivery_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;

  static String login() => '$base/v1/auth/login';
  static String register() => '$base/v1/auth/register';
  static String verifyOtp() => '$base/v1/auth/verify-email';
  static String resendOtp() => '$base/v1/auth/resend-otp';
  static String logout() => '$base/v1/auth/logout';
  static String changePassword() => '$base/v1/auth/change-password';
  static String forgotPassword() => '$base/v1/auth/forgot-password';
  static String resetPassword() => '$base/v1/auth/reset-password';
}
