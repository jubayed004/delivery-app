import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/router/routes.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/profile/model/profile_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:delivery_app/utils/multipart/multipart_body.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delivery_app/utils/config/app_config.dart';

class ProfileController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  Future<void> pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedImage.value = image;
    }
  }

  final profileLoading = false.obs;
  bool loadingProdileMethod(bool status) => profileLoading.value = status;
  final Rx<ProfileModel> profile = ProfileModel().obs;
  Future<void> getProfile() async {
    AppConfig.logger.i("Get Profile Method Called");
    loadingProdileMethod(true);
    try {
      final response = await apiClient.get(url: ApiUrls.getProfile());
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        final newData = ProfileModel.fromJson(response.data);
        profile.value = newData;
        loadingProdileMethod(false);
      }
    } catch (e) {
      loadingProdileMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  final updateProfileLoading = false.obs;
  bool loadingUpdateProfileMethod(bool status) =>
      updateProfileLoading.value = status;
  Future<void> updateProfile({required Map<String, String> body}) async {
    loadingUpdateProfileMethod(true);
    final token = await localService.getToken() ?? "";
    try {
      List<MultipartBody> multipartBody = [];

      if (selectedImage.value != null && selectedImage.value!.path.isNotEmpty) {
        multipartBody.add(
          MultipartBody(
            fieldKey: "profile_image",
            file: File(selectedImage.value!.path),
          ),
        );
      }
      final response = await apiClient.uploadMultipart(
        url: ApiUrls.updateProfile(),
        files: multipartBody,
        method: "PATCH",
        token: token,
        fields: body,
      );
      AppConfig.logger.i(response.data);
      if (response.statusCode == 200) {
        await getProfile();
        loadingUpdateProfileMethod(false);
        AppToast.success(message: response.data["message"].toString());
        AppRouter.route.pop();
        return; // Add return to stop execution
      } else {
        loadingUpdateProfileMethod(false);
        AppToast.error(message: response.data["message"].toString());
      }
    } catch (e) {
      loadingUpdateProfileMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
    getProfile();
  }
}
