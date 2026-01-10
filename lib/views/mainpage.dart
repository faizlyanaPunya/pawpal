import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/submitpetpage.dart';
import 'package:pawpal/views/petdetailspage.dart';

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
    loadPets('', '');
  }

  List<MyPet> listPets = [];
  List<MyPet> filteredPets = [];
  String status = 'Loading...';
  late double screenWidth, screenHeight;
  String selectedFilter = 'All';

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
      backgroundColor: Colors.grey.shade100,
      appBar: buildModernAppBar(),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listPets.isEmpty
                  ? Expanded(child: _buildEmptyState())
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
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
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PetDetailsPage(
                                      pet: listPets[index],
                                      user: widget.user,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // this is to display the pet image at the home page (pet listing page)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: screenWidth * 0.28,
                                        height: screenWidth * 0.22,
                                        color: Colors.grey[200],
                                        child: Image.network(
                                          '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${listPets[index].pet_id}_1.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.pets,
                                                  size: 60,
                                                  color: Colors.grey,
                                                );
                                              },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // this is to display the pet name at the home page (pet listing page)
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

                                          // this is to display the pet type at the home page (pet listing page)
                                          Text(
                                            listPets[index].pet_type.toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                221,
                                                0,
                                                0,
                                                0,
                                              ),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),

                                          // this is to display pet age at the home page (pet listing page)
                                          Text(
                                            "${listPets[index].pet_age ?? 'Unknown'} years old",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: const Color.fromARGB(
                                                255,
                                                0,
                                                0,
                                                0,
                                              ),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                          const SizedBox(height: 6),

                                          // this is to display pet category at the home page (pet listing page)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                255,
                                                87,
                                                152,
                                                154,
                                              ).withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              listPets[index].category
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                  255,
                                                  87,
                                                  152,
                                                  154,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
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

      // if user click the floating action button it will direct to submit pet page
      // where you can submit a pe
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetPage(user: widget.user),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 87, 152, 154),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // this is to display the app bar at the home page
  // with search and filter functionality
  AppBar buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 87, 152, 154),
      foregroundColor: Colors.white,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "PawPal",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Find Your Perfect Companion",
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        //when click search icon it will show search dialog
        _buildAppBarIcon(
          icon: Icons.search,
          tooltip: "Search",
          onTap: showSearchDialog,
        ),
        //when click filter icon it will show filter dialog
        _buildAppBarIcon(
          icon: Icons.filter_list,
          tooltip: "Filter",
          onTap: showFilterDialog,
        ),
        //when click refresh icon it will reload the pet list
        _buildAppBarIcon(
          icon: Icons.refresh,
          tooltip: "Refresh",
          onTap: () => loadPets('', ''),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }

  // if search result is empty it will show this widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            status.isEmpty ? "No pets available" : status,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // if user click search icon it will show search dialog
  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Search Pets",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (value) {
                        // validation : if user didn't enter anything show snackbar
                        if (value.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a search term"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        _performSearch(value.trim());
                      },
                      decoration: InputDecoration(
                        hintText: "e.g. Totty, Simba, Bella",
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(147, 158, 158, 158),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              87,
                              152,
                              154,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final query = searchController.text.trim();
                            if (query.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a search term"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            _performSearch(query);
                          },
                          child: const Text("Search"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // this is to show filter dialog
  void showFilterDialog() {
    String tempSelectedFilter = selectedFilter;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter by Pet Type",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RadioListTile<String>(
                      title: const Text('All'),
                      value: 'All',
                      groupValue: tempSelectedFilter,
                      activeColor: Color.fromARGB(255, 87, 152, 154),
                      onChanged: (String? value) {
                        setDialogState(() {
                          tempSelectedFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Cat'),
                      value: 'Cat',
                      groupValue: tempSelectedFilter,
                      activeColor: Color.fromARGB(255, 87, 152, 154),
                      onChanged: (String? value) {
                        setDialogState(() {
                          tempSelectedFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Dog'),
                      value: 'Dog',
                      groupValue: tempSelectedFilter,
                      activeColor: Color.fromARGB(255, 87, 152, 154),
                      onChanged: (String? value) {
                        setDialogState(() {
                          tempSelectedFilter = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Other'),
                      value: 'Other',
                      groupValue: tempSelectedFilter,
                      activeColor: Color.fromARGB(255, 87, 152, 154),
                      onChanged: (String? value) {
                        setDialogState(() {
                          tempSelectedFilter = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 87, 152, 154),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedFilter = tempSelectedFilter;
                            });
                            Navigator.pop(context);
                            _performFilter(tempSelectedFilter);
                          },
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // here perform search operation
  void _performSearch(String query) {
    if (query.isEmpty) {
      loadPets('', selectedFilter == 'All' ? '' : selectedFilter);
    } else {
      loadPets(query, selectedFilter == 'All' ? '' : selectedFilter);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  // here perform filter operation
  void _performFilter(String filter) {
    if (filter == 'All') {
      loadPets('', '');
    } else {
      loadPets('', filter);
    }
  }

  // here load pets from the server with search and filter parameters
  void loadPets(String searchQuery, String filterType) async {
    setState(() {
      listPets.clear();
      status = "Loading...";
    });

    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/get_my_pet.php?search=$searchQuery&filter=$filterType',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          final pets = <MyPet>[];
          for (var item in jsonResponse['data']) {
            pets.add(MyPet.fromJson(item));
          }

          setState(() {
            listPets = pets;
            status = "";
          });
        } else {
          setState(() {
            listPets.clear();
            status = "No pets found";
          });
        }
      } else {
        setState(() {
          listPets.clear();
          status = "Failed to load pets";
        });
      }
    } catch (e) {
      setState(() {
        listPets.clear();
        status = "Error loading pets";
      });
      print("Error fetching pets: $e");
    }
  }
}
