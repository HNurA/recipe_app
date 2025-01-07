import 'package:flutter/material.dart';

import '../pages/view_all_items.dart';

class BannerToExplore extends StatelessWidget {
  const BannerToExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.red,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 33,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cook the best\nrecipes at home",
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 33,
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // we will make the function later
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewAllItems(),
                      ),
                    );
                  },
                  child: const Text(
                    "Explore",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Image(
              image: AssetImage("assets/images/chef.png"),
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
