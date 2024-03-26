import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? currentLatLng;

  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    requestLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:currentLatLng!=null? GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: currentLatLng!,
            zoom: 15.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ):const Center(
          child: SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),),
        ),
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.request();

    if (permissionStatus == PermissionStatus.granted) {
      print("Success");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentLatLng = LatLng(position.latitude, position.longitude);
      });
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });
    } else {
      // Permission denied
    }
  }
}
