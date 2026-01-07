import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import 'package:masar_app/features/home/map/customer_map_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ===== Location & Tracking =====
  LatLng? myLocation;
  List<LatLng> trackingPoints = [];
  StreamSubscription<Position>? positionStream;
  bool isTracking = false;

  // ===== Customers & Routing =====
  List<Marker> customerMarkers = [];
  List<LatLng> navigationRoute = [];

  bool isLoading = true;        // تحميل أولي
  bool isMapReady = false;      // الخريطة + الماركرز
  bool isRouteLoading = false;  // تحميل المسار

  @override
  void initState() {
    super.initState();
    _loadMapAndCustomers();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  // ================= STEP 1 =================
  // تحميل الخريطة + العملاء فقط (سريع)
  Future<void> _loadMapAndCustomers() async {
    final markers = await CustomersMapService.getCustomerMarkers(context);

    setState(() {
      customerMarkers = markers;
      isMapReady = true;
      isLoading = false;
    });

    // بعد ما الخريطة تظهر نبدأ location والمسار
    _initLocationAndRoute();
  }

  // ================= STEP 2 =================
  // تحميل الموقع + أفضل مسار (في الخلفية)
  Future<void> _initLocationAndRoute() async {
    setState(() => isRouteLoading = true);

    await Geolocator.requestPermission();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final location = LatLng(position.latitude, position.longitude);

    final clientPoints = customerMarkers.map((m) => m.point).toList();
    final orderedClients = _sortByNearest(location, clientPoints);
    final route = await _buildRoadRoute(location, orderedClients);

    setState(() {
      myLocation = location;
      trackingPoints.add(location);
      navigationRoute = route;
      isRouteLoading = false;
    });
  }

  // ================= TRACKING =================
  void _startTracking() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      final point = LatLng(position.latitude, position.longitude);

      setState(() {
        myLocation = point;
        trackingPoints.add(point);
      });
    });

    setState(() => isTracking = true);
  }

  void _stopTracking() {
    positionStream?.cancel();
    positionStream = null;
    setState(() => isTracking = false);
  }

  // ================= SORT =================
  List<LatLng> _sortByNearest(LatLng start, List<LatLng> points) {
    final distance = Distance();
    final remaining = List<LatLng>.from(points);
    final sorted = <LatLng>[];

    LatLng current = start;

    while (remaining.isNotEmpty) {
      remaining.sort(
            (a, b) => distance(current, a).compareTo(distance(current, b)),
      );
      final nearest = remaining.removeAt(0);
      sorted.add(nearest);
      current = nearest;
    }

    return sorted;
  }

  // ================= OSRM =================
  Future<List<LatLng>> _getRoadRoute(LatLng start, LatLng end) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final coords = data['routes'][0]['geometry']['coordinates'] as List;

    return coords.map((c) => LatLng(c[1], c[0])).toList();
  }

  Future<List<LatLng>> _buildRoadRoute(
      LatLng start,
      List<LatLng> orderedClients,
      ) async {
    List<LatLng> fullRoute = [];
    LatLng current = start;

    for (final client in orderedClients) {
      final segment = await _getRoadRoute(current, client);
      fullRoute.addAll(segment);
      current = client;
    }

    return fullRoute;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading || !isMapReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملاحة'),
        actions: [
          if (isRouteLoading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: 'tracking_fab',
        onPressed: myLocation == null
            ? null
            : isTracking
            ? _stopTracking
            : _startTracking,
        backgroundColor: isTracking ? Colors.red : Colors.green,
        child: Icon(isTracking ? Icons.stop : Icons.play_arrow),
      ),

      body: FlutterMap(
        options: MapOptions(
          initialCenter:
          myLocation ?? customerMarkers.first.point,
          initialZoom: 15,
        ),
        children: [
          // ===== MAP =====
          TileLayer(
            urlTemplate:
            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),

          // ===== NAVIGATION ROUTE =====
          if (navigationRoute.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: navigationRoute,
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),

          // ===== TRACKING LINE =====
          if (trackingPoints.length > 1)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: trackingPoints,
                  strokeWidth: 3,
                  color: Colors.green,
                ),
              ],
            ),

          // ===== MARKERS =====
          MarkerLayer(
            markers: [
              if (myLocation != null)
                Marker(
                  width: 40,
                  height: 40,
                  point: myLocation!,
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ...customerMarkers,
            ],
          ),
        ],
      ),
    );
  }
}
