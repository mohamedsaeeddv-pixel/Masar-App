import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class LocationService {
  // 1. وظيفة جلب الموقع الحالي (نقطة)
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // 2. وظيفة فحص المنطقة (بياخد إحداثيات ويرجع اسم المنطقة من الـ JSON)
  static Future<String?> getAreaFromCoords(double lat, double lng) async {
    try {
      final String response = await rootBundle.loadString('assets/areas.json');
      final data = json.decode(response);
      final userPoint = mp.LatLng(lat, lng);

      for (var feature in data['features']) {
        if (feature['geometry']['type'] == 'Polygon') {
          // تحويل إحداثيات الـ Polygon من الـ JSON لنقاط يفهمها التطبيق
          // لاحظ عكس الترتيب [1] ثم [0] لأن الـ JSON بيبدأ بالـ Longitude
          List<mp.LatLng> polygonPoints = (feature['geometry']['coordinates'][0] as List)
              .map((c) => mp.LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();

          if (mp.PolygonUtil.containsLocation(userPoint, polygonPoints, false)) {
            return feature['properties']['SHYK_ARNAME'] ?? feature['properties']['SHYK_ANA_1'];
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // 3. وظيفة هتحتاجها "بعدين" (بتجيب كل البيانات عشان ترسمها على خريطة)
  static Future<List<Map<String, dynamic>>> getAllPolygons() async {
    final String response = await rootBundle.loadString('assets/areas.json');
    final data = json.decode(response);
    return (data['features'] as List).map((f) => {
      'name': f['properties']['SHYK_ARNAME'],
      'geometry': f['geometry']['coordinates'][0], // الإحداثيات اللي هتحتاجها للرسم
    }).toList();
  }
}