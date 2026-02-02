import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/professional_info/model/professional_info_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';

class ProfessionalInfoController extends GetxController {
  // ============= Get Driver Info =============
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  final loading = ApiStatus.loading.obs;
  void loadingMethod(ApiStatus status) => loading.value = status;
  Rx<ProfessionalInfoModel?> professionalInfo = Rx<ProfessionalInfoModel?>(
    null,
  );

  Future<void> getDriverInfo() async {
    try {
      loadingMethod(ApiStatus.loading);
      final response = await apiClient.get(url: ApiUrls.getDriverInfo());
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        professionalInfo.value = ProfessionalInfoModel.fromJson(response.data);
        if (professionalInfo.value?.data == null) {
          loadingMethod(ApiStatus.noDataFound);
        } else {
          loadingMethod(ApiStatus.completed);
        }
        return;
      } else {
        loadingMethod(ApiStatus.error);
        AppConfig.logger.e(response.data);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      loadingMethod(ApiStatus.error);
      AppConfig.logger.e(e);
    }
  }
}
