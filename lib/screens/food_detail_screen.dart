import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  final String foodName;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> description;
  final List<String> recipe;

  const FoodDetailPage({
    Key? key,
    required this.foodName,
    required this.imageUrl,
    required this.ingredients,
    required this.description,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              const SizedBox(height: 16.0),
              Text('재료: ${ingredients.join(', ')}', style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 16.0),
              Text('음식 설명: ${description.join(' ')}', style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 16.0),
              Text('레시피:', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ...recipe.map((step) => Text(step, style: TextStyle(fontSize: 16.0))).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
