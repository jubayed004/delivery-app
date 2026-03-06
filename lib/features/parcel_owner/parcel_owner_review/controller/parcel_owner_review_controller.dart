import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_review/model/parcel_owner_review_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:get/get.dart';

class ParcelOwnerReviewController extends GetxController {
  final String parcelId;
  ParcelOwnerReviewController({required this.parcelId});

  final ApiClient apiClient = sl();

  //=================== Review List ===================
  final Rx<ApiStatus> status = ApiStatus.loading.obs;
  final RxList<ReviewItem> reviews = <ReviewItem>[].obs;
  final RxInt averageRating = 0.obs;
  final RxInt totalReviews = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getReviews();
  }

  Future<void> getReviews() async {
    try {
      status.value = ApiStatus.loading;
      final response = await apiClient.get(url: ApiUrls.getReview());
      AppConfig.logger.i(response.data);

      if (response.statusCode == 200) {
        final data = ParcelOwnerReviewModel.fromJson(response.data);
        averageRating.value = data.averageRating ?? 0;
        totalReviews.value = data.meta?.total ?? 0;
        reviews.value = data.data ?? [];
        status.value = ApiStatus.completed;
      } else {
        status.value = ApiStatus.error;
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      status.value = ApiStatus.error;
      AppConfig.logger.e(e.toString());
    }
  }

  //=================== Create Review ===================
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
        getReviews(); // Reload list
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
