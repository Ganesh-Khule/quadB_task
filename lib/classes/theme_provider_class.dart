import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isSelected = false;

  bool get isSelectedData => _isSelected;

  void isClicked(){
    _isSelected = !isSelectedData;
    notifyListeners();
  }

}