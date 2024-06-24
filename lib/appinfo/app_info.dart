import 'package:capstone_project_carpool/models/address_model.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier
{
  AddressModel? startingPointLocation;
  AddressModel? destinationPointLocation;

  void updateStartingPointLocation(AddressModel startingPointModel)
  {
    startingPointLocation = startingPointModel;
    notifyListeners();
  }


  void updateDestinationPointLocation(AddressModel destinationPointModel)
  {
    destinationPointLocation = destinationPointModel;
    notifyListeners();
  }
}