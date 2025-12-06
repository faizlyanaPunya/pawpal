import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/submitpetpage.dart';

class MainPage extends StatefulWidget {
  final User? user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    loadPets();
  }

  List<MyPet> listPets = [];
  String status = 'Loading...';
  late double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
            onPressed: () {
              loadPets();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listPets.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_outlined, size: 64),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listPets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width:
                                          screenWidth * 0.28, // more responsive
                                      height:
                                          screenWidth *
                                          0.22, // balanced aspect ratio
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${listPets[index].pet_id}_1.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // TEXT AREA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // PET NAME
                                        Text(
                                          listPets[index].pet_name.toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // TYPE
                                        Text(
                                          listPets[index].pet_type.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          listPets[index].category.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          listPets[index].description
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetPage(user: widget.user),
            ),
          ); // Action for the button
        },
        backgroundColor: Color.fromARGB(255, 87, 152, 154),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void loadPets() {
    // TODO: implement loadServices
    listPets.clear();
    setState(() {
      status = "Loading...";
    });
    http.get(Uri.parse('${MyConfig.baseUrl}/pawpal/api/get_my_pet.php')).then((
      response,
    ) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        // log(jsonResponse.toString());
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          // has data → load to list
          listPets.clear();
          for (var item in jsonResponse['data']) {
            listPets.add(MyPet.fromJson(item));
          }
          setState(() {
            status = "";
          });
        } else {
          // success but EMPTY data
          setState(() {
            listPets.clear();
            status = "Not Available";
          });
        }
      } else {
        // request failed
        setState(() {
          listPets.clear();
          status = "Failed to load services";
        });
      }
    });
  }
}
