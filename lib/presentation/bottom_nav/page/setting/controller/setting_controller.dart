import 'package:get/get.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/model/ProfileModel.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

import '../../../../../core/routes/route_path.dart';
import '../../../../../helper/local_db/local_db.dart';
import '../../../../../helper/local_db/shareprefs_helper.dart';

class SettingController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final Rx<Data?> profile = Rx<Data?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.driverProfileGet,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = ProfileModel.fromJson(response.body);
        profile.value = model.data;
      } else {
        final message =
            response.body?['message'] ??
            response.body?['error'] ??
            'Failed to load profile.';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }




  static Future<void> logout() async {
    await SharePrefsHelper.clearUserSession();

    // Clear all GetX controllers
    Get.deleteAll(force: true);

    // Go to Login Screen
    Get.offAllNamed(RoutePath.login);
  }
}
