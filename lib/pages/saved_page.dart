import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Provider/saved_provider.dart';
import 'package:recipe_app/pages/recipe_details_page.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    final provider = SavedProvider.of(context);
    final savedItems = provider.saveds;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        title: const Text(
          "Saved Recipes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: savedItems.isEmpty
          ? const Center(
              child: Text(
                "No Saved Recipes Yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                String savedRecipeId = savedItems[index];
                return GestureDetector(
                  onTap: () {
                    // Get the document snapshot for the tapped recipe
                    FirebaseFirestore.instance
                        .collection("Recipes")
                        .doc(savedRecipeId)
                        .get()
                        .then((documentSnapshot) {
                      if (documentSnapshot.exists) {
                        // Pass the document snapshot to the RecipeDetailsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              documentSnapshot: documentSnapshot,
                            ),
                          ),
                        );
                      } else {
                        // Handle error (recipe not found)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Recipe not found."),
                          ),
                        );
                      }
                    });
                  },
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Recipes")
                        .doc(savedRecipeId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text("Error loading saved recipes"),
                        );
                      }
                      var savedRecipe = snapshot.data!;
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          savedRecipe['image'],
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
                                        savedRecipe['category'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        savedRecipe['name'],
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
                                            "${savedRecipe['cal']} Cal",
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
                                            "${savedRecipe['time']} Min",
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
                          ),
                          // for delete button
                          Positioned(
                            top: 50,
                            right: 35,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  provider.toggleFavorites(savedRecipe);
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
