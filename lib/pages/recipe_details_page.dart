import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/Provider/quantity.dart';
import 'package:recipe_app/Provider/saved_provider.dart';
import 'package:recipe_app/Widget/quantity_increment_decrement.dart';
import '../Widget/my_icon_button.dart';

class RecipeDetailsPage extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailsPage({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  bool isCooking = false;
  List<bool> checkedIngredients = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<double> baseAmounts = widget.documentSnapshot['ingAmount']
          .map<double>((amount) => double.parse(amount.toString()))
          .toList();
      Provider.of<QuantityProvider>(context, listen: false)
          .setBaseIngredientAmounts(baseAmounts);

      setState(() {
        checkedIngredients = List.generate(
          widget.documentSnapshot['ingImage'].length,
          (index) => false,
        );
      });
    });
  }

  void toggleCookingMode() {
    setState(() {
      isCooking = !isCooking;
      if (!isCooking) {
        checkedIngredients =
            List.generate(checkedIngredients.length, (index) => false);
      }
    });
  }

  void _showNutritionFacts(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nutrition Facts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        for (int i = 0;
                            i < widget.documentSnapshot['nutFactsName'].length;
                            i++)
                          TableRow(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  widget.documentSnapshot['nutFactsName'][i],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  widget.documentSnapshot['nutFactsNum'][i],
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = SavedProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: startCookingAndSaveButton(provider),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.documentSnapshot['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.documentSnapshot['category'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Iconsax.flash_1,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Iconsax.clock,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _showNutritionFacts(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "Nutrition Facts",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "How many servings?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemove: () => quantityProvider.decreaseQuantity(),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          if (isCooking)
                            Column(
                              children: List.generate(
                                widget.documentSnapshot['ingImage'].length,
                                (index) => SizedBox(
                                  height: 70,
                                  child: Checkbox(
                                    value: checkedIngredients[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        checkedIngredients[index] =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          Column(
                            children: widget.documentSnapshot['ingImage']
                                .map<Widget>(
                                  (imageUrl) => Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          imageUrl,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot['ingName']
                                .map<Widget>((ingredient) => SizedBox(
                                      height: 70,
                                      child: Center(
                                        child: Text(ingredient,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade900,
                                            )),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const Spacer(),
                          Column(
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>((amount) => SizedBox(
                                      height: 70,
                                      child: Center(
                                        child: Text("${amount}g",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade900,
                                            )),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.documentSnapshot['description'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndSaveButton(SavedProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade900,
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              foregroundColor: Colors.white,
            ),
            onPressed: toggleCookingMode,
            child: Text(
              isCooking ? "End Cooking" : "Start Cooking",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            onPressed: () {
              provider.toggleFavorites(widget.documentSnapshot);
            },
            icon: Icon(
              provider.isExist(widget.documentSnapshot)
                  ? Icons.bookmark
                  : Icons.bookmark_outline,
              color: provider.isExist(widget.documentSnapshot)
                  ? Colors.red
                  : Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
