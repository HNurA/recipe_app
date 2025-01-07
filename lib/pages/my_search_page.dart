import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/pages/my_category_page.dart';
import 'package:recipe_app/pages/search_bar_page.dart';

class MySeachPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  headerParts(),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchBarPage()),
                      );
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
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('App-Category')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final categories = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0, // Even closer horizontal spacing
                      mainAxisSpacing: 2.0, // Even closer vertical spacing
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                category: category['name'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0), // Reduced padding
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GridTile(
                              child: Image.network(
                                category['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
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

  Row headerParts() {
    return const Row(
      children: [
        Text(
          "What would you\nlike to cook today?",
          style:
              TextStyle(fontSize: 34, fontWeight: FontWeight.bold, height: 1),
        ),
        Spacer(),
      ],
    );
  }
}
