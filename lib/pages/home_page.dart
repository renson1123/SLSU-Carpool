import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:capstone_project_carpool/appinfo/app_info.dart';
import 'package:capstone_project_carpool/authentication/login_screen.dart';
import 'package:capstone_project_carpool/global/global_var.dart';
import 'package:capstone_project_carpool/methods/common_methods.dart';
import 'package:capstone_project_carpool/models/direction_details.dart';
import 'package:capstone_project_carpool/pages/search_destination_page.dart';
import 'package:capstone_project_carpool/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  Position? currentPositionOfUser;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 276;
  double bottomMapPadding = 0;
  double rideDetailsContainerHeight = 0;
  DirectionDetails? tripDirectionDetailsInfo;

  void updateMapTheme(GoogleMapController controller)
  {
    getJsonFileFromThemes("themes/night_style.json").then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async
  {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller)
  {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async
  {
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    await CommonMethods.convertGeographicCoordinatesIntoHumanReadableAddress(positionOfUser!, context);

    await getUserInfoAndCheckBlockStatus();

  }

  getUserInfoAndCheckBlockStatus() async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    await usersRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        if((snap.snapshot.value as Map)["blockStatus"] == "no")
        {
          setState(() {
            userName = (snap.snapshot.value as Map)["firstName"];
          });
        } else {
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
          cMethods.displaySnackBar("Client account is blocked, Contact Admin.", context);
        }
      } else
      {
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }

  displayUserRideDetailsContainer() async
  {
    // Directions API - Draw Routes between starting point and destination point
    await retrieveDirectionDetails();

    setState(() {
      searchContainerHeight = 0;
      bottomMapPadding = 240;
      rideDetailsContainerHeight = 242;
    });
  }

  retrieveDirectionDetails() async
  {
    var startingPointLocation = Provider.of<AppInfo>(context, listen: false).startingPointLocation;
    var destinationPointLocation = Provider.of<AppInfo>(context, listen: false).destinationPointLocation;

    var startingPointGeographicCoordinates = LatLng(startingPointLocation!.latitudePosition!, startingPointLocation.longitudePosition!);
    var destinationPointGeographicCoordinates = LatLng(destinationPointLocation!.latitudePosition!, destinationPointLocation.longitudePosition!);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingDialog(messageText: "Getting directions..."),
    );

    // Sending Request to Directions API
    var detailsFromDirectionAPI = await CommonMethods.getDirectionDetailsFromAPI(startingPointGeographicCoordinates, destinationPointGeographicCoordinates);

    setState(() {
      tripDirectionDetailsInfo = detailsFromDirectionAPI;
    });

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.black87,
        child: Drawer(
          backgroundColor: Colors.white10,
          child: ListView(
            children: [

              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              // header
              Container(
                color: Colors.black54,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                  ),
                  child: Row(
                    children: [

                      Image.asset(
                        "assets/images/avatarman.png",
                        width: 60,
                        height: 60,
                      ),

                      const SizedBox(width: 16,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4,),

                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),

              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              const SizedBox(height: 10,),

              // body
              ListTile(
                leading: IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                ),
                title: const Text(
                  "About",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: (){
                      
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [

          // Google Map
          GoogleMap(
            padding: EdgeInsets.only(top: 26, bottom: bottomMapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGoogleMap = mapController;

              // customizing map style
              // updateMapTheme(controllerGoogleMap!);

              googleMapCompleterController.complete(controllerGoogleMap);

              setState(() {
                bottomMapPadding = 300;
              });

              getCurrentLiveLocationOfUser();
            },
          ),

          // Drawer button
          Positioned(
              top: 36,
              left: 19,
              child: GestureDetector(
                onTap: ()
                {
                  sKey.currentState!.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const
                    [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: -80,
            child: Container(
              height: searchContainerHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Navigation
                  ElevatedButton(
                    onPressed: ()
                    {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),

                  // Trips Navigation
                  ElevatedButton(
                    onPressed: ()
                    {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                    ),
                    child: const Icon(
                      Icons.car_rental,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),

                  // Map Search Navigation
                  ElevatedButton(
                      onPressed: () async
                      {
                        var responseFromSearchPage = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchDestinationPage()));

                        if(responseFromSearchPage == "placeSelected")
                        {
                          displayUserRideDetailsContainer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 15,
                      ),
                  ),

                  // Message Navigation
                  ElevatedButton(
                    onPressed: ()
                    {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                    ),
                    child: const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),

                  // Profile Navigation
                  ElevatedButton(
                    onPressed: ()
                    {

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24)
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ride Details Container
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: rideDetailsContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                boxShadow:
                  [
                    BoxShadow(
                      color: Colors.white12,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(.7, .7),
                    ),
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SizedBox(
                        height: 190,
                        child: Card(
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .70,
                            color: Colors.black45,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (tripDirectionDetailsInfo != null) ? tripDirectionDetailsInfo!.distanceTextString! : "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          (tripDirectionDetailsInfo != null) ? tripDirectionDetailsInfo!.durationTextString! : "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: (){},
                                    child: Image.asset(
                                      "assets/images/uberexec.png",
                                      height: 122,
                                      width: 122,
                                    ),
                                  ),

                                  const Text(
                                    "\$ 12",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
