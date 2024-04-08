import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    print('광고를 확인하기 전 현재 카운트 값: $count');
    notifyListeners();
  }
}
