import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/other/model/terms_conditions_model.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';

class OtherController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final LocalService localService = sl<LocalService>();

  /// ============================= GET Terms Condition =====================================
  final Rx<TermsConditionsModel> termsConditionsData =
      TermsConditionsModel().obs;
  final Rx<ApiStatus> termsLoading = ApiStatus.completed.obs;
  void termsLoadingMethod(ApiStatus status) => termsLoading.value = status;

  Future<void> getTermsCondition() async {
    termsLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.termsConditions());

    if (response.statusCode == 200) {
      termsConditionsData.value = TermsConditionsModel.fromJson(response.data);
      termsLoadingMethod(ApiStatus.completed);
      AppToast.success(message: response.data['message']);
    } else {
      AppToast.error(message: response.data['message']);
      termsLoadingMethod(ApiStatus.error);
    }
  }

  /// ============================= GET Privacy Policy =====================================
  final Rx<TermsConditionsModel> privacyConditionsData =
      TermsConditionsModel().obs;
  final Rx<ApiStatus> privacyLoading = ApiStatus.completed.obs;
  void privacyLoadingMethod(ApiStatus status) => privacyLoading.value = status;

  Future<void> getPrivacyPolicy() async {
    privacyLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.privacyPolicy());
    if (response.statusCode == 200) {
      privacyConditionsData.value = TermsConditionsModel.fromJson(
        response.data,
      );
      privacyLoadingMethod(ApiStatus.completed);
      AppToast.success(message: response.data['message']);
    } else {
      AppToast.error(message: response.data['message']);
      privacyLoadingMethod(ApiStatus.error);
    }
  }

  /// ============================= GET FAQ =====================================
  final RxList<dynamic> faqData = [].obs;
  final Rx<ApiStatus> faqLoading = ApiStatus.completed.obs;
  void faqLoadingMethod(ApiStatus status) => faqLoading.value = status;

  Future<void> getFaq() async {
    faqLoadingMethod(ApiStatus.loading);
    var response = await apiClient.get(url: ApiUrls.faq());
    if (response.statusCode == 200) {
      faqData.value = response.data['data'] ?? [];
      faqLoadingMethod(ApiStatus.completed);
      AppToast.success(message: response.data['message']);
    } else {
      AppToast.error(message: response.data['message']);
      faqLoadingMethod(ApiStatus.error);
    }
  }

  /// ============================= Patch Change Password =====================================
  final RxBool changePasswordLoading = false.obs;
  void changePasswordLoadingMethod(bool loading) =>
      changePasswordLoading.value = loading;

  Future<void> changePassword({required Map<String, dynamic> body}) async {
    changePasswordLoadingMethod(true);
    var response = await apiClient.post(
      url: ApiUrls.changePassword(),
      body: body,
    );
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      changePasswordLoadingMethod(false);
      AppToast.success(message: response.data['message']);
      AppRouter.route.pop();
    } else {
      AppToast.error(
        message: response.data['message'] ?? "Something went wrong",
      );
      changePasswordLoadingMethod(false);
    }
  }
}
