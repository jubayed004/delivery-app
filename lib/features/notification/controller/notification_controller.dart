import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:delivery_app/features/notification/model/notification_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationController extends GetxController {
  final ApiClient apiClient = sl();

  Future<void> getNotify({
    required int pageKey,
    required PagingController<int, NotificationItem> pagingController,
  }) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getNotification(pageKey: pageKey),
      );
      AppConfig.logger.d(response.data);
      if (response.statusCode == 200) {
        final newData = NotificationsModel.fromJson(response.data);
        final newItems = newData.data ?? [];

        if (newItems.isEmpty) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        pagingController.error = 'An error occurred';
      }
    } catch (e) {
      pagingController.error = 'An error occurred';
    }
  }
}
