import 'package:get/get.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import '../model/PrivacyPolicyModel.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';

class PrivacyPolicyController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;
  final RxString description = "".obs;

  @override
  void onInit() {
    super.onInit();
    getPrivacyPolicy();
  }

  Future<void> getPrivacyPolicy() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.privacyAndPolicy,
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = PrivacyPolicyModel.fromJson(response.body);
        if (model.success == true && model.data?.description != null) {
          description.value = model.data!.description!;
        } else {
          AppSnackBar.fail(
            model.message ?? "Failed to load Privacy Policy",
          );
        }
      } else {
        final message =
            response.body?['message'] ??
            response.body?['error'] ??
            'Failed to load Privacy Policy';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
