import 'dart:async';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/common_controller/common_controller.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  RxInt start = 30.obs;
  RxBool isResendEnabled = false.obs;
  Timer? _timer;
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        start.value--;
      }
    });
  }
  void resendCode() {
    start.value = 30;
    isResendEnabled.value = false;
    startTimer();
  }

  // Sign Up Section
  RxBool signUpLoading = false.obs;
  bool signUpLoadingMethod(bool status) => signUpLoading.value = status;

  Future<void> signUp({required String nameSignUp,required String emailSignUp,required String passwordSignUp,required String confirmPassword}) async {
    try {
      signUpLoadingMethod(true);
      final body = {
        "full_name": nameSignUp.trim(),
        "email": emailSignUp.trim(),
        "password": passwordSignUp.trim(),
        "role": CommonController.to.isUser.value ? "CUSTOMER" : "DRIVER",
      };

      AppConfig.logger.i(body);

      final response = await apiClient.post(url: ApiUrls.register(), body: body, );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 201) {

        signUpLoadingMethod(false);

        AppToast.success(message: response.data?['message'].toString() ?? "Success",);

        final body = {"email": emailSignUp, "isSignUp": true};

        AppRouter.route.pushNamed(RoutePath.activeOtpScreen, extra: body);

      } else {
        signUpLoadingMethod(false);
        AppToast.error(message: response.data?['message'].toString() ?? "Error",);
        
      }
    } catch (err) {
      signUpLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }

  // Sign In Section
  RxBool signInLoading = false.obs;
  bool signInLoadingMethod(bool status) => signInLoading.value = status;

  final TextEditingController emailSignIn = TextEditingController();
  final TextEditingController passwordSignIn = TextEditingController();

  Future<void> signIn() async {
    try {
      signInLoadingMethod(true);

      final body = {"email": emailSignIn.text, "password": passwordSignIn.text};

      AppConfig.logger.i(body);

      final response = await apiClient.post(url: ApiUrls.login(), body: body);

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        signInLoadingMethod(false);
        AppToast.success(
          message: response.data?['message'].toString() ?? "Login Successful",
        );

        final data = response.data['data'];
        final token = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userId = data['user']['id'];
        final role = data['user']['role'];

        await localService.saveUserdata(
          token: token,
          refreshToken: refreshToken,
          id: userId,
          role: role,
        );

        if (role == "CUSTOMER") {
          AppRouter.route.goNamed(RoutePath.parcelOwnerNavScreen);
        } else {
          AppRouter.route.goNamed(RoutePath.driverNavScreen);
        }

        emailSignIn.clear();
        passwordSignIn.clear();
      } else {
        signInLoadingMethod(false);
        AppToast.error(
          message: response.data?['message'].toString() ?? "Login Failed",
        );
      }
    } catch (err) {
      signInLoadingMethod(false);
      AppConfig.logger.e(err);
      AppToast.error(message: "Something went wrong");
    }
  }
}
