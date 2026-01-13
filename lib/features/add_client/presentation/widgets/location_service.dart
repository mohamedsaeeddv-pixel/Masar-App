import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:easy_localization/easy_localization.dart'; // أضفنا المكتبة هنا

class LocationService {
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

  static Future<String?> getAreaFromCoords(double lat, double lng, String languageCode) async {
    try {
      final String response = await rootBundle.loadString('assets/areas.json');
      final data = json.decode(response);
      final userPoint = mp.LatLng(lat, lng);

      for (var feature in data['features']) {
        if (feature['geometry']['type'] == 'Polygon') {
          List<mp.LatLng> points = (feature['geometry']['coordinates'][0] as List)
              .map((c) => mp.LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();

          if (mp.PolygonUtil.containsLocation(userPoint, points, false)) {
            // منطق اختيار اسم المنطقة بناءً على اللغة
            if (languageCode == 'ar') {
              return feature['properties']['SHYK_ARNAME'] ?? feature['properties']['SHYK_ANA_1'];
            } else {
              // لو ملف الـ JSON فيه اسم بالإنجليزي (زي SHYK_ENNAME) استخدمه
              // لو مفيش، ممكن ترجع الاسم العربي كـ Fallback أو تعمل خريطة ترجمة
              return feature['properties']['SHYK_ENNAME'] ?? feature['properties']['SHYK_ARNAME'];
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}