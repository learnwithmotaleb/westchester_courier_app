import 'package:get/get.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import '../model/job_history_model.dart';

class JobHistoryController extends GetxController {
  final ApiClient _api = ApiClient();

  final RxBool isLoading = true.obs;
  final selectedFilter = 'Monthly'.obs;

  final Rx<Summary?> summary = Rx<Summary?>(null);
  final RxList<Data> historyList = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final response = await _api.get(url: ApiUrl.myHistory, isToken: true);

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['success'] == true) {
        final model = JobHistoryModel.fromJson(response.body);
        summary.value = model.summary;
        historyList.assignAll(model.data ?? []);
      } else {
        final errorMsg =
            response.body?['message'] ??
            response.statusText ??
            'Failed to load history.';
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
