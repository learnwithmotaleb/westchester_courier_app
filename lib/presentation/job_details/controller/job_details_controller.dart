import 'package:get/get.dart';

class JobDetailsController extends GetxController {
  // 0: Unaccepted (Accept/Reject)
  // 1: Accepted/Assigned (Arrive at Pickup)
  // 2: At Pickup (Confirm Pickup)
  // 3: In Transit (Arrive at Delivery)
  // 4: At Drop (Complete Delivery -> proof page)
  // 5: Done (Job Completed)
  final rxStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final bool isAccepted = args['isAccepted'] as bool? ?? false;
    if (isAccepted) {
      rxStep.value = 1;
    } else {
      rxStep.value = 0;
    }
  }

  void acceptRequest() {
    rxStep.value = 1;
  }

  void arriveAtPickup() {
    rxStep.value = 2;
  }

  void confirmPickup() {
    rxStep.value = 3;
  }

  void arriveAtDelivery() {
    rxStep.value = 4;
  }

  void completeDelivery() {
    // Navigation to Proof of Delivery page will be triggered from UI
  }

  void markAsDone() {
    rxStep.value = 5;
  }
}
