import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context)
  {
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
          ],
        ),
      ),
    );
  }
}
