import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Peta extends StatefulWidget {
  _PetaState createState() => _PetaState();}

class _PetaState extends State<Peta> {
  Completer<GoogleMapController> _controller = Completer();

  void initState() {super.initState();}
  void _onMapCreated(GoogleMapController controller) {_controller.complete(controller);}

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("PETA"),backgroundColor: Colors.lightGreenAccent[700],),
        body: Stack(children: <Widget>[_peta(context),])
    );
  }

  Widget _peta(BuildContext context) {
    return Container(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width,
        child: GoogleMap(onMapCreated: _onMapCreated, mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(-1.265386, 116.831200), zoom: 14),
          markers: {marker1},
        )
    );
  }
  Marker marker1 = Marker(markerId: MarkerId("TOKO 1"), position: LatLng(-1.277025, 116.829049),
      infoWindow: InfoWindow(title: "TOKO MAKMUR"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen,),

  );
}

