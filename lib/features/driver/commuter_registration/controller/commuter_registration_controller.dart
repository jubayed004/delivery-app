import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/config/app_config.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CommuterRegistrationController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  Rx<XFile?> numberPlateImage = Rx<XFile?>(null);
  Rx<XFile?> licenceImage = Rx<XFile?>(null);
  RxList<XFile> carImages = <XFile>[].obs;

  Future<void> pickImage(String imageType) async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      if (imageType == 'numberPlate') {
        numberPlateImage.value = image;
      } else if (imageType == 'licence') {
        licenceImage.value = image;
      } else if (imageType == 'car') {
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

  RxBool registerCommuterLoading = false.obs;
  bool registerCommuterLoadingMethod(bool status) =>
      registerCommuterLoading.value = status;
  Future<void> registerCommuter({required String body}) async {
    registerCommuterLoadingMethod(true);
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

    final response = await apiClient.uploadMultipart(
      fields: jsonDecode(body),
      url: ApiUrls.register(),
      files: multipart,
      method: 'POST',
      token: token,
    );
    AppConfig.logger.i(response.data);
    registerCommuterLoadingMethod(false);

    if (response.statusCode == 201) {
      registerCommuterLoadingMethod(false);

      AppToast.success(
        message: response.data?["message"].toString() ?? "Success",
      );

      AppRouter.route.pushNamed(RoutePath.driverNavScreen);
    } else {
      registerCommuterLoadingMethod(false);
      AppToast.error(message: response.data?["message"].toString() ?? "Error");
    }
    // try {

    // } catch (e) {
    //   registerCommuterLoadingMethod(false);
    //   AppConfig.logger.e(e);
    //   AppToast.error(message: "Something went wrong");
    // }
  }
}
