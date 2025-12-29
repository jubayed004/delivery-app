import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();
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
}
