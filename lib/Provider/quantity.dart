import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];

  List<bool> isChecked = [];

  int get currentNumber => _currentNumber;
  // Set initial ingredient amounts
  void setBaseIngredientAmounts(List<double> amounts) {
    debugPrint("Amounts: $amounts");
    _baseIngredientAmounts = amounts;
    notifyListeners(); // Hatanın burada olup olmadığını kontrol edin
  }

  // Update ingredient amounts based on the quantity
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) => (amount * _currentNumber).toStringAsFixed(2))
        .toList();
  }

  // increase servings
  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  // decrease servings
  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
  }

  void resetCheckboxes() {
    isChecked = List<bool>.filled(
        _baseIngredientAmounts.length, false); // Reset checkboxes
    notifyListeners();
  }
}
