import 'package:flutter/material.dart';

class RegionProvider with ChangeNotifier {
  String _selectedRegion = 'laPaz';

  String get selectedRegion => _selectedRegion;

  void changeRegion(String newRegion) {
    _selectedRegion = newRegion;
    notifyListeners();
  }
}
