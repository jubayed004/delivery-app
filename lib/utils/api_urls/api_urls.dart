import 'package:delivery_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;

  static String login() => '$base/v1/auth/login';
  static String register() => '$base/v1/auth/register';
  static String verifyOtp() => '$base/v1/auth/verify-otp';
  static String resendOtp() => '$base/v1/auth/resend-otp';
  static String logout() => '$base/v1/auth/logout';
  static String changePassword() => '$base/v1/auth/change-password';
  static String forgotPassword() => '$base/v1/auth/forget-password';
  static String resetPassword() => '$base/v1/auth/reset-password';
  // =========== Customer Api Urls ===========
  static String getProfile() => '$base/v1/user/get-me';
  static String updateProfile() => '$base/v1/user/update-me';
  // =========== Parcel Owner Api Urls ===========
  static String getHomeData({required String status, required int page}) =>
      '$base/v1/parcel/get-my-parcels?status=$status&page=$page&limit=10';
  static String createParcel() => '$base/v1/parcel/create';
  static String createDetailsParcel({required String id}) =>
      '$base/v1/parcel/get/$id';
  static String getDeliveryPrice({required String id}) =>
      '$base/v1/parcel/request-for-price/$id';
}
