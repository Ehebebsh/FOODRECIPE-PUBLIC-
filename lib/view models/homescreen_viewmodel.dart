import 'dart:convert';
import 'package:flutter/material.dart';

class FoodImageLoader {
  Future<List<dynamic>> loadEasyFoodImages(BuildContext context) async {
    List<String> easyFoodImages = [];
    List<dynamic> easyFoodJsonList = [];

    String easyFoodJsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/easyfood.json');
    easyFoodJsonList = json.decode(easyFoodJsonString);

    for (var item in easyFoodJsonList) {
      easyFoodImages.add(item['image']);
    }

    // easyFoodImages와 easyFoodJsonList를 반환
    return [easyFoodImages, easyFoodJsonList];
  }

  Future<List<dynamic>> loadHardFoodImages(BuildContext context) async {
    List<String> hardFoodImages = [];
    List<dynamic> hardFoodJsonList = [];

    String hardFoodJsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/hardfood.json');
    hardFoodJsonList = json.decode(hardFoodJsonString);

    for (var item in hardFoodJsonList) {
      hardFoodImages.add(item['image']);
    }

    // hardFoodImages와 hardFoodJsonList를 반환
    return [hardFoodImages, hardFoodJsonList];
  }
}

