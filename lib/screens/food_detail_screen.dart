import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const FoodDetailPage({Key? key, required this.foodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodData['name']),
      ),
      body: ListView(
        children: [
          Image.network(
            foodData['image'],
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text('재료'),
            subtitle: Text(foodData['ingredients'].join(', ')),
          ),
          ListTile(
            title: Text('레시피'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var step in foodData['recipe'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(step),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodDetailPageDemo extends StatelessWidget {
  Future<Map<String, dynamic>> _loadFoodData(BuildContext context) async {
    // JSON 파일을 읽어오기
    String jsonString = await rootBundle.loadString('assets/food_data.json');
    // JSON 데이터 파싱
    return jsonDecode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFoodData(context),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return FoodDetailPage(foodData: snapshot.data!);
        }
      },
    );
  }
}
