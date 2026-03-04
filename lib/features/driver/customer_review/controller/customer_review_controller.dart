import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomerReviewController extends GetxController {
  final ApiClient apiClient = sl();

  final PagingController<int, ReviewItem> reviewController = PagingController(
    firstPageKey: 1,
  );

  final RxInt averageRating = 0.obs;
  final RxInt totalReviews = 0.obs;

  @override
  void onInit() {
    super.onInit();
    reviewController.addPageRequestListener((pageKey) {
      getCustomerReviews(pageKey: pageKey);
    });
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  Future<void> getCustomerReviews({required int pageKey}) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getParcelOwnerReview(pageKey: pageKey),
      );
      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        final data = ParcelOwnerReviewModel.fromJson(response.data);
        averageRating.value = data.averageRating ?? 0;
        totalReviews.value = data.meta?.total ?? 0;

        final newItems = data.data ?? [];
        final isLastPage = newItems.length < 10;

        if (isLastPage) {
          reviewController.appendLastPage(newItems);
        } else {
          reviewController.appendPage(newItems, pageKey + 1);
        }
      } else {
        reviewController.error =
            response.data['message'] ?? 'Error loading reviews';
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      reviewController.error = e;
      AppConfig.logger.e(e.toString());
    }
  }

  @override
  void refresh() => reviewController.refresh();
}
