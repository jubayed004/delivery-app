import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ParcelOwnerReviewController extends GetxController {
  final String parcelId;
  ParcelOwnerReviewController({required this.parcelId});

  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  //===================  My Parcel Review Pagination ===================
  final PagingController<int, ReviewItem> reviewController = PagingController(
    firstPageKey: 1,
  );
  RxInt averageRating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    reviewController.addPageRequestListener((pageKey) {
      getParcelOwnerReview(pageKey: pageKey);
    });
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  Future<void> getParcelOwnerReview({required int pageKey}) async {
    try {
      final response = await apiClient.get(
        url: ApiUrls.getParcelOwnerReview(pageKey: pageKey),
        skipLogoutOn401:
            true, // Don't logout globally if this endpoint returns 401
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final newData = ParcelOwnerReviewModel.fromJson(response.data);
        averageRating.value = newData.averageRating ?? 0;

        final newItems = newData.data ?? [];
        final isLastPage = newItems.length < 10;

        if (isLastPage) {
          reviewController.appendLastPage(newItems);
        } else {
          reviewController.appendPage(newItems, pageKey + 1);
        }
      } else {
        reviewController.error = 'Error loading reviews';
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      reviewController.error = e;
      AppConfig.logger.e(e.toString());
    }
  }

  final RxBool createReviewLoading = false.obs;

  Future<void> createReview({
    required String parcelId,
    required double rating,
    required String feedback,
  }) async {
    try {
      createReviewLoading.value = true;
      final body = {
        "parcel_id": parcelId.trim(),
        "rating": rating.toInt(),
        "feedback": feedback.trim(),
      };

      AppConfig.logger.i(body);
      final response = await apiClient.post(
        url: ApiUrls.createReview(),
        body: body,
      );

      AppConfig.logger.i(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        createReviewLoading.value = false;
        AppToast.success(message: response.data["message"].toString());
        reviewController.refresh(); // Reload list to show the new review
        AppRouter.route.pop(); // Close dialog
      } else {
        createReviewLoading.value = false;
        AppToast.error(message: response.data["message"].toString());
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      createReviewLoading.value = false;
      AppConfig.logger.e(e.toString());
      AppToast.error(message: e.toString());
    }
  }
}
