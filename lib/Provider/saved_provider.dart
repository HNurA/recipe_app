import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedProvider extends ChangeNotifier {
  List<String> _savedIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get saveds => _savedIds;

  SavedProvider() {
    loadSaved();
  }

  // toggle favorites states
  void toggleFavorites(DocumentSnapshot product) async {
    String productId = product.id;
    if (_savedIds.contains(productId)) {
      _savedIds.remove(productId);
      await _removeSaved(productId); // remove from the favorites
    } else {
      _savedIds.add(productId);
      await _save(productId); // add to favorites
    }
    notifyListeners();
  }

  // check if a product is favorited
  bool isExist(DocumentSnapshot product) {
    return _savedIds.contains(product.id);
  }

  // add favorites to firestore
  Future<void> _save(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).set({
        'isFavorite':
            true, // create the userFavorite collection and add item as favorites in firestore
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Remove favorite from firestore
  Future<void> _removeSaved(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // load favorites from firestore
  Future<void> loadSaved() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _savedIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // Static method to access the provider from any context
  static SavedProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<SavedProvider>(
      context,
      listen: listen,
    );
  }
}
