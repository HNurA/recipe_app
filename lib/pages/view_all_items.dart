import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Widget/food_items_display.dart';
import 'package:recipe_app/Widget/my_icon_button.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp =
      FirebaseFirestore.instance.collection("Recipes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove the default back button
        elevation: 0,
        actions: [
          const SizedBox(width: 15),
          MyIconButton(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Text(
            "All Recipes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 15),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 15,
          right: 5,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.85),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Column(
                        children: [
                          FoodItemsDisplay(documentSnapshot: documentSnapshot),
                        ],
                      );
                    },
                  );
                }
                // it means if snapshot has data then show the data otherwise show the progress bar
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
