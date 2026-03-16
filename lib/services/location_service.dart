import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static const double distanceFilter = 10; // meters

  // Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      final permission = await Permission.location.status;
      if (!permission.isGranted) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get location stream
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter.toInt(),
        timeLimit: const Duration(minutes: 5),
      ),
    );
  }

  // Calculate distance between two coordinates
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Get Google Maps URL for location
  String getGoogleMapsUrl({
    required double latitude,
    required double longitude,
  }) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  // Get address from coordinates (reverse geocoding)
  Future<String?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final addresses = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (addresses.isNotEmpty) {
        final address = addresses.first;
        return '${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return null;
  }

  // Get coordinates from address (geocoding)
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
    return null;
  }

  // Format location for display
  String formatLocationDisplay(double latitude, double longitude) {
    return '$latitude, $longitude';
  }
}
