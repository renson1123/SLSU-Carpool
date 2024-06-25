import 'package:capstone_project_carpool/appinfo/app_info.dart';
import 'package:capstone_project_carpool/global/global_var.dart';
import 'package:capstone_project_carpool/methods/common_methods.dart';
import 'package:capstone_project_carpool/models/address_model.dart';
import 'package:capstone_project_carpool/models/prediction_model.dart';
import 'package:capstone_project_carpool/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionPlaceUI extends StatefulWidget
{
  PredictionModel? predictedPlaceData;

  PredictionPlaceUI({super.key, this.predictedPlaceData,});

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlaceUIState();
}

class _PredictionPlaceUIState extends State<PredictionPlaceUI>
{
  // Place Details - Places API
  fetchClickedPlaceDetails(String placeID) async
  {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingDialog(messageText: "Getting details..."),
    );

    String urlPlaceDetailsAPI = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$googleMapKey";

    var responseFromPlaceDetailsAPI = await CommonMethods.sendRequestToAPI(urlPlaceDetailsAPI);

    Navigator.pop(context);

    if(responseFromPlaceDetailsAPI == "error")
    {
      return;
    }

    if(responseFromPlaceDetailsAPI["status"] == "OK")
    {
      AddressModel destinationPointLocation = AddressModel();

      destinationPointLocation.placeName = responseFromPlaceDetailsAPI["result"]["name"];
      destinationPointLocation.latitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lat"];
      destinationPointLocation.longitudePosition = responseFromPlaceDetailsAPI["result"]["geometry"]["location"]["lng"];
      destinationPointLocation.placeID = placeID;

      Provider.of<AppInfo>(context, listen: false).updateDestinationPointLocation(destinationPointLocation);

      Navigator.pop(context, "placeSelected");
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
        onPressed: ()
        {
          fetchClickedPlaceDetails(widget.predictedPlaceData!.place_id.toString());
        },
        style: ElevatedButton.styleFrom
        (
          backgroundColor: Colors.white,
        ),
        child: Container(
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Row(
                children: [

                  const Icon(
                    Icons.share_location,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 13,),
                  
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.predictedPlaceData!.main_text.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 3,),

                        Text(
                          widget.predictedPlaceData!.secondary_text.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),
            ],
          ),
        ),
    );
  }
}
