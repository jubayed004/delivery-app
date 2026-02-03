import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/driver/professional_info/model/professional_info_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/enum/app_enum.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfessionalInfoController extends GetxController {
  // ============= Get Driver Info =============
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  final ImagePicker _imagePicker = ImagePicker();

  Rx<XFile?> numberPlateImage = Rx<XFile?>(null);
  Rx<XFile?> licenceImage = Rx<XFile?>(null);
  RxList<XFile> carImages = <XFile>[].obs;

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
        loadingMethod(ApiStatus.completed);
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

  // ============= Image Handling =============
  Future<void> pickImage(String imageType) async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      if (imageType == 'number_plate_image') {
        numberPlateImage.value = image;
      } else if (imageType == 'license_image') {
        licenceImage.value = image;
      } else if (imageType == 'vehicle_images') {
        if (carImages.length < 5) {
          carImages.add(image);
        }
      }
    }
  }

  void removeCarImage(int index) {
    if (index < carImages.length) {
      carImages.removeAt(index);
    }
  }

  // ============= Update Driver Info =============
  RxBool updateDriverInfoLoading = false.obs;
  bool updateDriverInfoLoadingMethod(bool status) =>
      updateDriverInfoLoading.value = status;

  Future<void> updateDriverInfo({required Map<String, dynamic> body}) async {
    updateDriverInfoLoadingMethod(true);
    final token = await localService.getToken();
    final List<MultipartBody> multipart = [];

    if (numberPlateImage.value != null &&
        numberPlateImage.value!.path.isNotEmpty) {
      multipart.add(
        MultipartBody(
          fieldKey: "number_plate_image",
          file: File(numberPlateImage.value!.path),
        ),
      );
    }

    if (licenceImage.value != null && licenceImage.value!.path.isNotEmpty) {
      multipart.add(
        MultipartBody(
          fieldKey: "license_image",
          file: File(licenceImage.value!.path),
        ),
      );
    }

    if (carImages.isNotEmpty) {
      for (var image in carImages) {
        multipart.add(
          MultipartBody(fieldKey: "vehicle_images", file: File(image.path)),
        );
      }
    }

    if (multipart.isEmpty) {
      final jsonBody = jsonDecode(body['data'] as String);
      AppConfig.logger.i("Sending JSON body: $jsonBody");

      final response = await apiClient.put(
        url: ApiUrls.updateDriverInfo(),
        body: jsonBody,
        token: token,
      );

      _handleUpdateResponse(response);
    } else {
      final response = await apiClient.uploadMultipart(
        fields: body,
        url: ApiUrls.updateDriverInfo(),
        files: multipart,
        method: 'PATCH',
        token: token,
      );
      _handleUpdateResponse(response);
    }
  }

  void _handleUpdateResponse(response) {
    AppConfig.logger.i(response.data);
    updateDriverInfoLoadingMethod(false);

    if (response.statusCode == 200) {
      AppToast.success(
        message: response.data?["message"].toString() ?? "Updated Successfully",
      );
      getDriverInfo(); // Refresh data
      AppRouter.route.pop();
    } else {
      AppConfig.logger.e(response.data);
      AppToast.error(
        message: response.data?["message"].toString() ?? "Update Failed",
      );
    }
  }
}
