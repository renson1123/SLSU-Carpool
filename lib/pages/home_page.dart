import 'dart:async';

import 'package:capstone_project_carpool/global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Stack(
        children: [
          
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGoogleMap = mapController;

              googleMapCompleterController.complete(controllerGoogleMap);
            },
          ),
        ],
      ),
    );
  }
}
