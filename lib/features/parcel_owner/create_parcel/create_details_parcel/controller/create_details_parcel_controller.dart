import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';

import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/create_parcel/create_details_parcel/model/parcel_details_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateDetailsParcelController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  final loading = ApiStatus.loading.obs;
  void loadingMethod(ApiStatus status) => loading.value = status;

  Rx<ParcelDetailsModel?> parcelDetails = Rx<ParcelDetailsModel?>(null);

  Future<void> createDetailsParcel({required String id}) async {
    loadingMethod(ApiStatus.loading);
    final token = await localService.getToken();
    try {
      final response = await apiClient.get(
        url: ApiUrls.createDetailsParcel(id: id),
        token: token,
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        parcelDetails.value = ParcelDetailsModel.fromJson(response.data);
        if (parcelDetails.value?.data == null) {
          loadingMethod(ApiStatus.noDataFound);
        } else {
          loadingMethod(ApiStatus.completed);
        }
        return;
      } else {
        loadingMethod(ApiStatus.error);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      loadingMethod(ApiStatus.error);
      AppToast.error(message: e.toString());
    }
  }

  var getDeliveryPriceStatus = ApiStatus.completed.obs;
  void getDeliveryPriceStatusMethod(ApiStatus status) =>
      getDeliveryPriceStatus.value = status;
  Future<void> deliveryPrice({required String id}) async {
    getDeliveryPriceStatusMethod(ApiStatus.loading);
    final token = await localService.getToken();
    try {
      final response = await apiClient.patch(
        url: ApiUrls.getDeliveryPrice(id: id),
        token: token,
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        getDeliveryPriceStatusMethod(ApiStatus.completed);
        AppRouter.route.goNamed(RoutePath.parcelOwnerNavScreen, extra: 2);

        AppToast.success(message: response.data["message"].toString());
        return;
      } else {
        getDeliveryPriceStatusMethod(ApiStatus.error);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      getDeliveryPriceStatusMethod(ApiStatus.error);
      AppToast.error(message: e.toString());
    }
  }
}
