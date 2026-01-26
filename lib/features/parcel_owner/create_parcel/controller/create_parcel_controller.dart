import 'dart:io';

import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/route_path.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class CreateParcelController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  Rx<XFile?> parcelImage = Rx<XFile?>(null);

  Future<void> pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    parcelImage.value = image;
  }

  final RxBool createParcelLoading = false.obs;
  bool createParcelLoadingMethod(bool status) =>
      createParcelLoading.value = status;

  Future<void> createParcel({required Map<String, dynamic> body}) async {
    createParcelLoadingMethod(true);
    final token = await localService.getToken();
    final List<MultipartBody> multipart = [];

    if (parcelImage.value != null && parcelImage.value!.path.isNotEmpty) {
      multipart.add(
        MultipartBody(
          fieldKey: "parcel_image",
          file: File(parcelImage.value!.path),
        ),
      );
    }

    final response = await apiClient.uploadMultipart(
      fields: body,
      url: ApiUrls.createParcel(),
      files: multipart,
      method: 'POST',
      token: token,
    );
    print(response.data);
    createParcelLoadingMethod(false);

    if (response.statusCode == 201) {
      createParcelLoadingMethod(false);

      AppToast.success(
        message: response.data?["message"].toString() ?? "Success",
      );

      AppRouter.route.pushNamed(RoutePath.driverNavScreen);
    } else {
      createParcelLoadingMethod(false);
      AppToast.error(message: response.data?["message"].toString() ?? "Error");
    }
  }
}
