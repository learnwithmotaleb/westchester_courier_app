import 'package:get/get.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/presentation/bottom_nav/page/home/model/delivery_summary_model.dart';
import 'package:westchester/presentation/bottom_nav/page/home/model/my_delivery_model.dart';

class HomeController extends GetxController {
  final _api = ApiClient();

  // ─── State ────────────────────────────────────────────────────────────────
  final RxBool isLoading = true.obs;
  final Rx<Data?> summaryData = Rx<Data?>(null);
  final RxBool hasError = false.obs;

  final RxBool isDeliveriesLoading = true.obs;
  final RxList<DeliveryData> deliveriesList = <DeliveryData>[].obs;
  final RxBool hasDeliveriesError = false.obs;

  // ─── Convenience getters ──────────────────────────────────────────────────
  String get pendingTask =>
      summaryData.value?.pendingTaskCount?.toString() ?? '—';

  String get completedTask =>
      summaryData.value?.completedTaskCount?.toString() ?? '—';

  @override
  void onInit() {
    super.onInit();
    fetchStats();
    fetchMyDeliveries();
  }

  // ─── API Call ─────────────────────────────────────────────────────────────
  Future<void> fetchStats() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _api.get(
        url: ApiUrl.deliveryStatsSummary,
        isToken: true,
      );

      if (response.statusCode == 200 && response.body != null) {
        final model = DeliverySummaryModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          summaryData.value = model.data;
        } else {
          hasError.value = true;
        }
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyDeliveries() async {
    isDeliveriesLoading.value = true;
    hasDeliveriesError.value = false;

    try {
      final response = await _api.get(url: ApiUrl.deliveryMy, isToken: true);

      if (response.statusCode == 200 && response.body != null) {
        final model = MyDeliveryModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          deliveriesList.value = model.data!;
        } else {
          hasDeliveriesError.value = true;
        }
      } else {
        hasDeliveriesError.value = true;
      }
    } catch (e) {
      hasDeliveriesError.value = true;
    } finally {
      isDeliveriesLoading.value = false;
    }
  }
}
