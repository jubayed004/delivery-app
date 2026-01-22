import 'package:get/get.dart';
import 'package:delivery_app/share/model/language_model.dart';
import 'package:logger/logger.dart';

class AppConfig {
  //API Base URL
  //static const String baseURL = "http://10.10.20.36:5000/api";
  static const String baseURL = "https://whxmt66k-5000.inc1.devtunnels.ms/api";
  // static const String baseURL = "http://10.10.20.9:7050";
  static const String fontFamily = "";
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: false,
      printEmojis: true,
    ),
  );

  //Default Language Key
  static const String defaultLanguageKey = "en";

  static const defaultProfile =
      "https://img.freepik.com/premium-photo/casual-young-man-shirt_146377-2992.jpg";

  static List<LanguageModel> languages = [
    // LanguageModel(imageUrl: "", languageName: 'german'.tr, countryCode: 'DE', languageCode: 'de'),
    LanguageModel(
      imageUrl: "",
      languageName: 'english'.tr,
      countryCode: 'US',
      languageCode: 'en',
    ),
  ];

  /*
  static final List<Map<String, dynamic>> factFastList = [
    {"icon": Icon(Iconsax.location), "title": AppStrings.location, "subTitle": "Los Angeles, CA – Griffith Park Fields"},
    {"icon": Icon(Iconsax.shop), "title": AppStrings.experience, "subTitle": "5 years"},
    {"icon": Icon(Iconsax.verify_otp), "title": AppStrings.certificate, "subTitle": "3", "eye": Icon(Iconsax.eye)},
  ];
*/
}
