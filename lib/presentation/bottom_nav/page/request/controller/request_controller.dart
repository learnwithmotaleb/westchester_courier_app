import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/presentation/bottom_nav/page/request/model/request_model.dart';

class RequestController extends GetxController {
  final ApiClient _api = ApiClient();

  final RxBool isLoading = true.obs;
  final RxList<Data> requestsList = <Data>[].obs;
  
  // Grouped by date
  final RxMap<String, List<Data>> groupedRequests = <String, List<Data>>{}.obs;

  final RxInt pendingCount = 0.obs;
  final RxInt acceptedCount = 0.obs;

  // Pagination
  int page = 1;
  final int limit = 20;
  bool hasMore = true;
  final RxBool isFetchingMore = false.obs;

  // Filters
  final RxString selectedType = 'all'.obs; // 'all', 'pending', 'accepted'
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMore || isFetchingMore.value) return;
      isFetchingMore.value = true;
      page++;
    } else {
      isLoading.value = true;
      page = 1;
      hasMore = true;
      requestsList.clear();
    }

    try {
      final url = '${ApiUrl.deliverRequests}'
          '?page=$page'
          '&limit=$limit'
          '&type=${selectedType.value}'
          '&month=${selectedMonth.value}'
          '&year=${selectedYear.value}';

      final response = await _api.get(
        url: url,
        isToken: true,
      );

      if (response.statusCode == 200 && response.body != null) {
        final model = RequestModel.fromJson(response.body);
        if (model.success == true && model.data != null) {
          if (loadMore) {
            requestsList.addAll(model.data!);
          } else {
            requestsList.assignAll(model.data!);
          }
          
          if (model.meta != null) {
            pendingCount.value = model.meta!.pendingRequestCount ?? 0;
            acceptedCount.value = model.meta!.acceptedCount ?? 0;
            hasMore = page < (model.meta!.totalPages ?? 1);
          } else {
            hasMore = false;
          }

          _groupRequests();
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch requests');
      }
    } catch (e) {
      debugPrint('Error fetching requests: $e');
      if (!loadMore) {
        Get.snackbar('Error', 'An error occurred while fetching requests');
      }
    } finally {
      if (loadMore) {
        isFetchingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void updateTypeFilter(String type) {
    selectedType.value = type;
    fetchRequests();
  }

  void updateMonthFilter(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    fetchRequests();
  }

  void _groupRequests() {
    final Map<String, List<Data>> tempGroup = {};
    for (var request in requestsList) {
      // Use formattedDate or fallback to "Unknown Date"
      final dateString = request.formattedDate ?? 'Unknown Date';
      if (!tempGroup.containsKey(dateString)) {
        tempGroup[dateString] = [];
      }
      tempGroup[dateString]!.add(request);
    }
    groupedRequests.assignAll(tempGroup);
  }

  Future<void> onRefresh() async {
    await fetchRequests();
  }

  // Accept Request
  Future<void> acceptRequest(String id) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final response = await _api.patch(url: ApiUrl.acceptRequest(id), isToken: true);
      Get.back(); // close dialog
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body['success'] == true) {
          Get.snackbar('Success', response.body['message'] ?? 'Request Accepted');
          
          final index = requestsList.indexWhere((r) => r.sId == id);
          if (index != -1) {
            final request = requestsList[index];
            request.isAccepted = true;
            request.status = 'DRIVER_ACCEPTED';
            request.statusLabel = 'Accepted';
            requestsList[index] = request;
            _groupRequests(); // refresh groups
            
            pendingCount.value = (pendingCount.value - 1).clamp(0, 9999);
            acceptedCount.value += 1;
          }
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to accept request');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'An error occurred while accepting request');
    }
  }

  // Reject Request
  Future<void> rejectRequest(String id) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final response = await _api.patch(url: ApiUrl.rejectRequest(id), isToken: true);
      Get.back(); // close dialog
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body['success'] == true) {
          Get.snackbar('Success', response.body['message'] ?? 'Request Rejected');
          
          requestsList.removeWhere((r) => r.sId == id);
          _groupRequests();
          
          pendingCount.value = (pendingCount.value - 1).clamp(0, 9999);
        }
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to reject request');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'An error occurred while rejecting request');
    }
  }
}