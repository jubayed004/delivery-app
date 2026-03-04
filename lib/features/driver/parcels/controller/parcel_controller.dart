import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/parcels/model/parcel_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ParcelController extends GetxController {
  final ApiClient apiClient = sl<ApiClient>();
  final PagingController<int, DriverParcelItem> ongoingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, DriverParcelItem> completedController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    ongoingController.addPageRequestListener((pageKey) {
      getOngoingData(pageKey: pageKey);
    });
    completedController.addPageRequestListener((pageKey) {
      getCompletedData(pageKey: pageKey);
    });
  }

  @override
  void onClose() {
    ongoingController.dispose();
    completedController.dispose();
    super.onClose();
  }

  RxBool isLoadingOngoing = false.obs;
  RxBool isLoadingCompleted = false.obs;

  // Fetch Ongoing Parcels
  Future<void> getOngoingData({required int pageKey}) async {
    isLoadingOngoing(true);
    try {
      final response = await apiClient.get(
        url: ApiUrls.getHomeData(status: "ONGOING", page: pageKey),
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final data = DriverParcelModel.fromJson(response.data);
        final newItems = data.data?.data ?? [];
        final isLastPage = newItems.length < 10;
        if (isLastPage) {
          ongoingController.appendLastPage(newItems);
        } else {
          ongoingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        ongoingController.error = 'Error fetching data';
      }
    } catch (e) {
      ongoingController.error = e;
      AppConfig.logger.e(e);
    } finally {
      isLoadingOngoing(false);
    }
  }

  // Fetch Completed Parcels
  Future<void> getCompletedData({required int pageKey}) async {
    isLoadingCompleted(true);
    try {
      final response = await apiClient.get(
        url: ApiUrls.getHomeData(status: "COMPLETED", page: pageKey),
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final data = DriverParcelModel.fromJson(response.data);
        final newItems = data.data?.data ?? [];
        final isLastPage = newItems.length < 10;
        if (isLastPage) {
          completedController.appendLastPage(newItems);
        } else {
          completedController.appendPage(newItems, pageKey + 1);
        }
      } else {
        completedController.error = 'Error fetching data';
      }
    } catch (e) {
      completedController.error = e;
      AppConfig.logger.e(e);
    } finally {
      isLoadingCompleted(false);
    }
  }

  //=================== chat with Customer ===================

  final loadingChatWithCustomer = false.obs;
  void loadingChatWithCustomerMethod(bool status) =>
      loadingChatWithCustomer.value = status;
  Future<void> chatInitiateP2P({required String recipientId}) async {
    try {
      loadingChatWithCustomerMethod(true);
      final response = await apiClient.post(
        url: ApiUrls.chatInitiateP2P(),
        body: {"recipientId": recipientId},
      );
      AppConfig.logger.i("recipientId: $recipientId");
      AppConfig.logger.i(
        "ApiUrls.chatInitiateP2P(): ${ApiUrls.chatInitiateP2P()}",
      );
      AppConfig.logger.i("response.data: ${response.data}");
      if (response.statusCode == 200) {
        loadingChatWithCustomerMethod(false);
        final chatId = response.data["data"]["_id"];
        AppConfig.logger.i("chat Room Id: $chatId");
        AppRouter.route.pushNamed(RoutePath.chatScreen, extra: chatId);
        return;
      } else {
        loadingChatWithCustomerMethod(false);
        AppConfig.logger.e(response.data);
      }
    } catch (e) {
      loadingChatWithCustomerMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  final otpLoading = false.obs;
  void otpLoadingMethod(bool status) => otpLoading.value = status;

  Future<void> verifyParcelOtp(String parcelId, String otp) async {
    otpLoadingMethod(true);
    try {
      final response = await apiClient.post(
        url: ApiUrls.verifyParcelOtp(),
        body: {"parcel_id": parcelId, "otp": otp},
      );

      AppConfig.logger.d(response.data);

      if (response.statusCode == 200) {
        AppToast.success(message: response.data['message']);
        otpLoadingMethod(false);
        AppRouter.route.pop();
        ongoingController.refresh();
      } else {
        AppToast.error(message: response.data['message']);
        otpLoadingMethod(false);
      }
    } catch (e) {
      AppConfig.logger.e(e);
      AppToast.error(message: "An error occurred while fetching details.");
      otpLoadingMethod(false);
    } finally {
      otpLoadingMethod(false);
    }
  }
}
