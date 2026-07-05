import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../core/enums/app_role.dart';
import 'local_db.dart';

class RoleSelectionController extends GetxController {

  var selectedRole = Rx<AppRole?>(null);

  Future<void> selectRole(AppRole role) async {
    selectedRole.value = role;
    await SharePrefsHelper.saveRole(role);
    print("Role ${role.name} set successfully");

  }
}