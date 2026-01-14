import 'package:get/get.dart';
import 'package:delivery_app/features/auth/controller/auth_controller.dart';
import 'package:delivery_app/features/onboarding/controller/onboarding_controller.dart';
import 'package:delivery_app/features/other/controller/other_controller.dart';
import 'package:delivery_app/share/controller/language_controller.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:delivery_app/features/auth/otp/controller/otp_controller.dart';
import 'package:delivery_app/features/auth/reset/controller/reset_password_controller.dart';
import 'package:delivery_app/features/chat/controller/chat_controller.dart';
import 'package:delivery_app/features/driver/track_parcel/controller/track_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/all_commuter/controller/all_commuter_controller.dart';
import 'package:delivery_app/features/parcel_owner/my_parcel/controller/my_parcel_controller.dart';
import 'package:delivery_app/features/parcel_owner/refund/controller/refund_controller.dart';
import 'package:delivery_app/features/profile/controller/profile_controller.dart';

void initGetx() {
  //Auth
  Get.lazyPut(() => LanguageController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => OtpController(), fenix: true);
  Get.lazyPut(() => ResetPasswordController(), fenix: true);

  //Others
  Get.lazyPut(() => OtherController(), fenix: true);
  Get.lazyPut(() => OnboardingController(), fenix: true);
  Get.lazyPut(() => CommonController(), fenix: true);

  //Chat
  Get.lazyPut(() => ChatController(), fenix: true);

  //Driver
  Get.lazyPut(() => TrackParcelController(), fenix: true);

  //Parcel Owner
  Get.lazyPut(() => AllCommuterController(), fenix: true);
  Get.lazyPut(() => MyParcelController(), fenix: true);
  Get.lazyPut(() => RefundController(), fenix: true);

  //Profile
  Get.lazyPut(() => ProfileController(), fenix: true);
}
