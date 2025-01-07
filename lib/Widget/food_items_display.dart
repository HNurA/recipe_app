import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Provider/saved_provider.dart';
import 'package:recipe_app/pages/recipe_details_page.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = SavedProvider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeDetailsPage(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevents overflows
              children: [
                Hero(
                  tag: documentSnapshot['image'],
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          documentSnapshot['image'], //image from firestore
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  documentSnapshot['name'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Truncates long text
                  overflow: TextOverflow.ellipsis,
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
                      "${documentSnapshot['cal']} Cal",
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
                      "${documentSnapshot['time']} Min",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // for favorite button
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    provider.toggleFavorites(documentSnapshot);
                  },
                  child: Icon(
                    provider.isExist(documentSnapshot)
                        ? Icons.bookmark
                        : Icons.bookmark_border_outlined,
                    color: provider.isExist(documentSnapshot)
                        ? Colors.red
                        : Colors.black,
                    size: 20,
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
