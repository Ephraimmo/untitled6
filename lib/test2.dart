import 'dart:async';
import 'dart:math' show cos,sqrt,asin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:untitled6/utils/colors.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({required this.lat, required this.lng, required this.latUser, required this.lngUser, required this.orderNumber});

  final double lat;
  final double lng;
  final double latUser;
  final double lngUser;
  final String orderNumber;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId,Polyline> polylines = {};
  PolylinePoints polylinePoint = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition,destinationPosition;
  loc.LocationData? _currentPoision;
  LatLng curLocation         = LatLng(23.0525, 72.5667);
  LatLng destinationLocation = LatLng(23.0525, 72.5667);
  StreamSubscription<loc.LocationData>? locationSubscription;

  final markers = Set<Marker>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      curLocation = LatLng(widget.latUser, widget.lngUser);
      destinationLocation = LatLng(widget.lat, widget.lng);
      markers.add(Marker(markerId: const MarkerId('Me'),position: curLocation,infoWindow: InfoWindow(title: 'Me')));
      markers.add(Marker(markerId: const MarkerId('destination'),position: destinationLocation,infoWindow: InfoWindow(title: 'destination #${widget.orderNumber}')));
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Location'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: curLocation,
                    zoom: 16,
                  ),
                  markers: markers,

                  onMapCreated: (GoogleMapController controller){
                    _controller.complete(controller);
                  },

                ),
              ],
         )
    );
  }
}







