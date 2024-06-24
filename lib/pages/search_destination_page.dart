import 'package:capstone_project_carpool/global/global_var.dart';
import 'package:capstone_project_carpool/methods/common_methods.dart';
import 'package:capstone_project_carpool/models/prediction_model.dart';
import 'package:capstone_project_carpool/widgets/prediction_place_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appinfo/app_info.dart';

class SearchDestinationPage extends StatefulWidget
{
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage>
{
  TextEditingController startingPointTextEditingController = TextEditingController();
  TextEditingController destinationPointTextEditingController = TextEditingController();
  List<PredictionModel> destinationPointPredictionPlacesList = [];

  // Google Places API = Place AutoComplete
  searchLocation(String locationName) async
  {
    if(locationName.length > 1)
    {
      String apiPlacesUrl =  "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=$googleMapKey&components=country:ph";

      var responseFromPlacesAPI  = await CommonMethods.sendRequestToAPI(apiPlacesUrl);

      if(responseFromPlacesAPI == "Error")
      {
        return;
      }
      if (responseFromPlacesAPI["status"] == "OK")
      {
        var predictionResultInJSON = responseFromPlacesAPI["predictions"];
        var predictionList  = (predictionResultInJSON as List).map((eachPlacePrediction) => PredictionModel.fromJSON(eachPlacePrediction)).toList();

        setState(() {
          destinationPointPredictionPlacesList = predictionList;
        });

        print("predictionResultInJSON = " + predictionResultInJSON.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    String userAddress = Provider.of<AppInfo>(context, listen: false).startingPointLocation!.humanReadableAddress ?? "";
    startingPointTextEditingController.text = userAddress;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Card(
              elevation: 10,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [

                      const SizedBox(height: 6,),

                      // Icon button - Title
                      Stack(
                        children: [
                          GestureDetector(
                              onTap: ()
                              {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back, color: Colors.white,),
                            ),

                            const Center(
                              child: Text(
                                "Set Destination Location",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 18,),

                      // Starting Point TextField
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/initial.png",
                            height: 16,
                            width: 16,
                            ),

                          const SizedBox(width: 18,),

                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: TextField(
                                    controller: startingPointTextEditingController,
                                    decoration: const InputDecoration(
                                      hintText: "Starting Point Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 11, top: 9, bottom: 9),
                                    ),
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),


                      const SizedBox(height: 11,),

                      // Destination Point TextField
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/final.png",
                            height: 16,
                            width: 16,
                          ),

                          const SizedBox(width: 18,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  controller: destinationPointTextEditingController,
                                  onChanged: (inputText)
                                  {
                                    searchLocation(inputText);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Destination Point Address",
                                    fillColor: Colors.white12,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11, top: 9, bottom: 9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Display prediction results for destination place
            (destinationPointPredictionPlacesList.length > 0)
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index)
                      {
                        return Card(
                          elevation: 3,
                          child: PredictionPlaceUI(
                            predictedPlaceData: destinationPointPredictionPlacesList[index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 2,),
                      itemCount: destinationPointPredictionPlacesList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
