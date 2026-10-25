import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final locationName = 'Mendeteksi lokasi...'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      locationName.value = 'Mendeteksi lokasi...';

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        locationName.value = 'Aktifkan layanan lokasi';
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationName.value = 'Izin lokasi belum diberikan';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (kIsWeb) {
        locationName.value =
            '${position.latitude.toStringAsFixed(4)}, '
            '${position.longitude.toStringAsFixed(4)}';
        return;
      }

      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (places.isNotEmpty) {
        final place = places.first;

        locationName.value =
            place.subAdministrativeArea?.isNotEmpty == true
                ? place.subAdministrativeArea!
                : place.locality?.isNotEmpty == true
                    ? place.locality!
                    : place.administrativeArea?.isNotEmpty == true
                        ? place.administrativeArea!
                        : 'Lokasi ditemukan';
      } else {
        locationName.value = 'Lokasi ditemukan';
      }
    } catch (e) {
      locationName.value = 'Lokasi tidak tersedia';
      debugPrint('Error lokasi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
