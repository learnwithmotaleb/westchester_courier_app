import 'package:get/get.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import '../model/TermsConditionModel.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';

class TermsConditionController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final RxBool isLoading = false.obs;
  final RxString description = "".obs;

  @override
  void onInit() {
    super.onInit();
    getTermsCondition();
  }

  Future<void> getTermsCondition() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.termsCondition,
        isToken:
            true, // Assuming token might be needed, if not it just ignores it
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = TermsConditionModel.fromJson(response.body);
        if (model.success == true && model.data?.description != null) {
          description.value = model.data!.description!;
          AppSnackBar.success(model.message ?? "Terms & Conditions loaded successfully");
        } else {
          AppSnackBar.fail(
            model.message ?? "Failed to load Terms & Conditions",
          );
        }
      } else {
        final message =
            response.body?['message'] ??
            response.body?['error'] ??
            'Failed to load Terms & Conditions';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
