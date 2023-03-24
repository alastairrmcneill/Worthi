import 'package:flutter/material.dart';

// Provider notifier used to store the information displayed summary at the top
// of the main page
class DisplayNotifier extends ChangeNotifier {
  bool _showFromGraph = false;
  double _value = 0;
  double _deposited = 0;

  bool get showFromGraph => _showFromGraph;
  double get value => _value;
  double get deposited => _deposited;

  set setShowFromGraph(bool showFromGraph) {
    _showFromGraph = showFromGraph;
    notifyListeners();
  }

  set setValue(double value) {
    _value = value;
    notifyListeners();
  }

  set setDeposited(double deposited) {
    _deposited = deposited;
    notifyListeners();
  }
}
