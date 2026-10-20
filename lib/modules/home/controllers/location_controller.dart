import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final locationName = 'Meminta izin lokasi...'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      if (!await Geolocator.isLocationServiceEnabled()) {
        locationName.value = 'Aktifkan layanan lokasi';
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationName.value = 'Izin lokasi ditolak';
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;
        locationName.value =
            place.subAdministrativeArea ??
            place.locality ??
            place.administrativeArea ??
            'Lokasi ditemukan';
      } else {
        locationName.value = 'Lokasi ditemukan';
      }
    } catch (e) {
      locationName.value = 'Lokasi tidak tersedia';
    } finally {
      isLoading.value = false;
    }
  }
}
