import 'dart:convert';
import 'package:flutter/services.dart';

class FoodListModel {
  late final List<String> jsonFileNames;

  FoodListModel({required this.jsonFileNames});

  Future<List<dynamic>> loadJsonData() async {
    List<dynamic> combinedFoodList = [];

    for (String fileName in jsonFileNames) {
      String jsonData = await rootBundle.loadString('assets/$fileName.json');
      combinedFoodList.addAll(json.decode(jsonData));
    }

    return combinedFoodList;
  }
}
