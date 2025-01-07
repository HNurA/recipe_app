import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'recipe_details_page.dart'; // Make sure the correct path to RecipeDetailsPage is provided

class SearchBarPage extends StatefulWidget {
  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
        title: const Text(
          'Search Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(Icons.search_rounded),
                  fillColor: Colors.white,
                  hintText: "Search any recipes",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Recipes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final recipes = snapshot.data!.docs.where((recipe) {
                    final recipeName = recipe['name'].toString().toLowerCase();
                    return recipeName.contains(searchText);
                  }).toList();

                  if (recipes.isEmpty) {
                    return const Center(
                      child: Text(
                        'No recipes found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsPage(
                                documentSnapshot: recipe,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            recipe['image'],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe['category'] ?? "",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          recipe['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.flash_1,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              "${recipe['cal']} Cal",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(
                                              Iconsax.clock,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              "${recipe['time']} Min",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
