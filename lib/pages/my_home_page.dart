import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:recipe_app/Widget/banner.dart';
import 'package:recipe_app/Widget/food_items_display.dart';
import 'package:recipe_app/pages/my_search_page.dart';
import 'package:recipe_app/pages/saved_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomeContent(),
    MySeachPage(),
    const SavedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.bookmark,
                text: 'Saved',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomeContent extends StatelessWidget {
  const MyHomeContent({super.key});

  Future<List<DocumentSnapshot>> fetchRecipes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Queries to get all recipes from each category
    final queries = [
      firestore
          .collection("Recipes")
          .where('category', isEqualTo: "Soup")
          .get(),
      firestore
          .collection("Recipes")
          .where('category', whereIn: ["Meat", "Fish", "Chicken"]).get(),
      firestore
          .collection("Recipes")
          .where('category', whereIn: ["Sandwich", "Salad"]).get(),
      firestore
          .collection("Recipes")
          .where('category', isEqualTo: "Dessert")
          .get(),
    ];

    // Fetch all recipes for each category
    final List<QuerySnapshot> results = await Future.wait(queries);

    // Randomly pick one recipe from each category
    final random = List<DocumentSnapshot>.from(results.map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs[DateTime.now().millisecond % snapshot.docs.length];
      }
      return null; // If no recipe exists in a category
    }).where((doc) => doc != null));

    return random;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerParts(),
                    const SizedBox(height: 24),
                    const BannerToExplore(),
                    const SizedBox(height: 24),
                    const Text(
                      "Today's picks for you: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<DocumentSnapshot>>(
                      future: fetchRecipes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error fetching recipes"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text("No recipes found"));
                        }

                        final recipes = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 items per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4, // Adjust aspect ratio
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            return FoodItemsDisplay(
                              documentSnapshot: recipes[index],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row headerParts() {
    return const Row(
      children: [
        Text(
          "Welcome chef!",
          style:
              TextStyle(fontSize: 34, fontWeight: FontWeight.bold, height: 1),
        ),
        Spacer(),
      ],
    );
  }
}
