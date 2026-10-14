
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final pushNotifications = true.obs;

  final userName = 'Budi Santoso'.obs;
  final userEmail = 'budi.santoso@gmail.com'.obs;

  void toggleNotifications(bool value) {
    pushNotifications.value = value;
  }

  String get initials {
    final parts = userName.value.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
