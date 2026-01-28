import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/parcel_owner/parcel_owner_home/model/parcel_owner_home_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ParcelOwnerHomeController extends GetxController {
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  final PagingController<int, ParcelItem> ongoingController = PagingController(
    firstPageKey: 1,
  );
  final PagingController<int, ParcelItem> completedController =
      PagingController(firstPageKey: 1);

  // Loading states for each status
  RxBool isLoadingOngoing = false.obs;
  RxBool isLoadingCompleted = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners for pagination
    ongoingController.addPageRequestListener((pageKey) {
      getOngoingData(pageKey: pageKey);
    });
    completedController.addPageRequestListener((pageKey) {
      getCompletedData(pageKey: pageKey);
    });
  }

  @override
  void onReady() {
    super.onReady();
    getSingleOngoingData(pageKey: 1);
  }

  @override
  void onClose() {
    ongoingController.dispose();
    completedController.dispose();
    super.onClose();
  }

  // Fetch Ongoing Parcels
  Future<void> getOngoingData({required int pageKey}) async {
    isLoadingOngoing(true);
    final response = await apiClient.get(
      url: ApiUrls.getHomeData(status: "ONGOING", page: pageKey),
    );
    AppConfig.logger.i(response.data);
    if (response.statusCode == 200) {
      final data = HomeModel.fromJson(response.data);
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
    // try {

    // } catch (e) {
    //   ongoingController.error = e;
    //   AppToast.error(message: e.toString());
    // } finally {
    //   isLoadingOngoing(false);
    // }
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
        final data = HomeModel.fromJson(response.data);
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
      AppToast.error(message: e.toString());
    } finally {
      isLoadingCompleted(false);
    }
  }

  // Refresh all data
  void refreshAllData() {
    ongoingController.refresh();
    completedController.refresh();
  }

  // Single Ongoing Parcel Logic
  final Rx<ParcelItem?> firstParcel = Rx(null);
  final RxBool isSingleLoading = false.obs;

  Future<void> getSingleOngoingData({required int pageKey}) async {
    isSingleLoading.value = true;
    try {
      final response = await apiClient.get(
        url: ApiUrls.getHomeData(status: "ONGOING", page: pageKey),
      );
      if (response.statusCode == 200) {
        final data = HomeModel.fromJson(response.data);
        final newItems = data.data?.data ?? [];
        if (newItems.isNotEmpty) {
          firstParcel.value = newItems.first;
          // Optionally update controller if we want to keep it in sync, but not strictly needed for single view
          // ongoingController.appendLastPage(newItems);
        } else {
          firstParcel.value = null;
        }
      } else {
        // handle error
      }
    } catch (e) {
      AppToast.error(message: e.toString());
    } finally {
      isSingleLoading.value = false;
    }
  }
}
