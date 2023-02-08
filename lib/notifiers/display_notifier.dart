import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';

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
