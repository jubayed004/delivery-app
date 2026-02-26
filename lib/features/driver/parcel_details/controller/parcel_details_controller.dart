import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/parcel_details/model/parcel_details_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';

class ParcelDetailsController extends GetxController {
  final ApiClient apiClient = sl();
  final loading = ApiStatus.loading.obs;
  void loadingMethod(ApiStatus status) => loading.value = status;
  var parcelDetails = Rxn<ParcelDetailsData>();
  Future<void> getParcelDetails(String id) async {
    loadingMethod(ApiStatus.loading);
    try {
      final response = await apiClient.get(
        url: ApiUrls.getParcelDetails(id: id),
      );

      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        final parcelDetailsModel = ParcelDetailsModel.fromJson(response.data);
        parcelDetails.value = parcelDetailsModel.data;
        loadingMethod(ApiStatus.completed);
      } else {
        AppToast.error(message: response.data['message']);
        loadingMethod(ApiStatus.error);
      }
    } catch (e) {
      AppConfig.logger.e(e);
      AppToast.error(message: "An error occurred while fetching details.");
      loadingMethod(ApiStatus.error);
    } finally {
      loadingMethod(ApiStatus.completed);
    }
  }
}
