import 'dart:convert';

import 'package:capstone_project_carpool/global/global_var.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CommonMethods
{
  checkConnectivity(BuildContext context) async
  {
    var connectionResultList = await Connectivity().checkConnectivity();
    var connectionResult = connectionResultList.first;

    if(connectionResult != ConnectivityResult.mobile && connectionResult != ConnectivityResult.wifi)
      {
        if(!context.mounted) return;
        displaySnackBar("No internet, Check your connection and Try again.", context);
      }
  }

  displaySnackBar(String messageText, BuildContext context)
  {
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static sendRequestToAPI(String apiUrl) async
  {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try
    {
      if (responseFromAPI.statusCode == 200)
      {
        String dataFromAPI = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromAPI);
        return dataDecoded;
      }
      else
      {
        return "Error";
      }
    }
    catch (errorMsg)
    {
      return "Error";
    }
  }

  // Reverse Geocoding - is the process of converting geographic coordinates into a human-readable address.
  static Future<String> convertGeographicCoordinatesIntoHumanReadableAddress(Position position, BuildContext context) async
  {
    String humanReadableAddress = "";
    String apiGeocodingUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleMapKey";

    var responseFromAPI = await sendRequestToAPI(apiGeocodingUrl);

    if(responseFromAPI != "Error")
    {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];
      print("humanReadableAddress = " + humanReadableAddress);
    }

    return humanReadableAddress;
  }
}