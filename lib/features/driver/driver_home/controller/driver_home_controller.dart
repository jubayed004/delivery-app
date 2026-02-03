import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/driver_home/model/driver_home_model.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:delivery_app/core/di/injection.dart';

class DriverHomeController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  final PagingController<int, ParcelInformation> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getDriverParcels(page: pageKey),
      );
      AppConfig.logger.d(response.data);
      if (response.statusCode == 200) {
        final driverHomeModel = DriverHomeModel.fromJson(response.data);
        final newItems = driverHomeModel.data ?? [];
        final isLastPage = newItems.length < 10;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.error = response.data['message'];
      }
    } catch (error) {
      AppConfig.logger.e(error);
      pagingController.error = error;
    }
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
