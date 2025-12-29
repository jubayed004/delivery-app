
import 'package:delivery_app/utils/config/app_config.dart';

class ApiUrls {
  static const base = AppConfig.baseURL;

  static String login() => '$base/auth/login';
}
