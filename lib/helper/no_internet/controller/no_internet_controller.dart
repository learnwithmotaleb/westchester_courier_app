import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetController extends GetxController {
  final RxBool isConnected = true.obs;
  StreamSubscription<InternetStatus>? _subscription;
  static InternetController get to => Get.find<InternetController>();

  // ✅ Custom checker — multiple addresses
  final InternetConnection _checker = InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(uri: Uri.parse('https://google.com')),
      InternetCheckOption(uri: Uri.parse('https://cloudflare.com')),
      InternetCheckOption(uri: Uri.parse('https://apple.com')),
      InternetCheckOption(uri: Uri.parse('https://amazon.com')),
    ],
    useDefaultOptions: false,
  );

  @override
  void onInit() {
    super.onInit();
    _initConnection();
  }

  void _initConnection() {
    _checkInitialConnection();

    _subscription = _checker.onStatusChange.listen((status) {
      // ✅ 2 সেকেন্ড debounce — momentary drop ignore করবে
      Future.delayed(const Duration(seconds: 2), () {
        isConnected.value = status == InternetStatus.connected;
      });
    });
  }

  Future<void> _checkInitialConnection() async {
    final status = await _checker.hasInternetAccess;
    isConnected.value = status;
  }

  void setConnected() => isConnected.value = true;
  void setDisconnected() => isConnected.value = false;

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}