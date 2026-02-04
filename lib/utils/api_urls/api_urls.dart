import 'package:delivery_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;

  static String login() => '$base/v1/auth/login';
  static String register() => '$base/v1/auth/register';
  static String verifyOtp() => '$base/v1/auth/verify-otp';
  static String resendOtp() => '$base/v1/auth/resend-otp';
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
  static String rejectAndCounterOffer({required String id}) =>
      '$base/v1/parcel/reject-and-counter/$id';
  static String rejectFinalOffer({required String id}) =>
      '$base/v1/parcel/reject-price/$id';
  static String acceptFinalOffer({required String id}) =>
      '$base/v1/parcel/accept-price/$id';
  //============== Settting===================

  static String changePassword() => '$base/v1/auth/change-password';
  static String termsConditions() => '$base/v1/settings/terms/get';
  static String privacyPolicy() => '$base/v1/settings/privacy/get';
  static String faq() => '$base/v1/settings/faq/get-all';
  static String logout() => '$base/v1/auth/logout';

  //============== Driver===================
  static String getDriverInfo() => '$base/v1/driver/get-driver-info';
  static String updateDriverInfo() => '$base/v1/driver/update-info';
  static String registerDriver() => '$base/v1/driver/info';
  static String getDriverParcels({required int page}) =>
      '$base/v1/driver/available-for-driver?page=$page&limit=10';

  static String getParcelDetails({required String id}) =>
      '$base/v1/parcel/get/$id';
}
