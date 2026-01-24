import 'package:delivery_app/core/di/injection.dart';
import 'package:delivery_app/core/service/datasource/local/local_service.dart';
import 'package:delivery_app/core/service/datasource/remote/api_client.dart';
import 'package:delivery_app/features/profile/model/profile_model.dart';
import 'package:delivery_app/helper/toast/toast_helper.dart';
import 'package:delivery_app/utils/api_urls/api_urls.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
  final ApiClient apiClient = sl();
  final LocalService localService = sl();

  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxBool isUpdateLoading = false.obs;

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
    loadingProdileMethod(true);
    try {
      final response = await apiClient.get(url: ApiUrls.getProfile());
      if (response.statusCode == 200) {
        final newData = ProfileModel.fromJson(response.data);
        profile.value = newData;
      }
      loadingProdileMethod(false);
    } catch (e) {
      loadingProdileMethod(false);
      AppToast.error(message: e.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
    getProfile();
  }
}
