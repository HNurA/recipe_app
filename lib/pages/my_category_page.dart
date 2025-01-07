import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/Widget/food_items_display.dart';
import 'package:recipe_app/Widget/my_icon_button.dart';
import 'package:recipe_app/pages/view_all_items.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: category == "All"
          ? null // Don't show the app bar when category is "All"
          : AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading:
                  false, // Remove the default back button
              elevation: 0,
              actions: [
                const SizedBox(width: 15),
                MyIconButton(
                  icon: Icons.arrow_back_ios,
                  pressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                Text(
                  category == "All" ? "All Recipes" : "$category Recipes",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 15),
              ],
            ),
      body: category == "All"
          ? const ViewAllItems()
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Recipes')
                  .where('category', isEqualTo: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final recipes = snapshot.data!.docs;
                if (recipes.isEmpty) {
                  return const Center(
                    child: Text('No recipes found in this category.'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    itemCount: recipes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return FoodItemsDisplay(
                        documentSnapshot: recipe,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
