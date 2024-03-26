import 'package:flutter/material.dart';
import 'package:foodrecipe/cons/colortable.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const FoodDetailPage({Key? key, required this.foodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodData['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              foodData['image'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[300]!,
                      Colors.grey[200]!,
                      Colors.white
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  foodData['name'],
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  for (var tag in foodData['tags'])
                    Container(
                      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[200]!,
                            Colors.white
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[300]!,
                      Colors.grey[200]!,
                      Colors.white
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (foodData['description'] != null)
                      for (var desc in foodData[
                      'description']) // Iterate over each description
                        Text(
                          desc.toString(), // Convert dynamic to string
                        ),
                    if (foodData['description'] == null ||
                        foodData['description'].isEmpty)
                      Text('No description available'),
                    // Show message if description is null or empty
                  ],
                ),
              ),
            ),

            Divider(height: 20, thickness: 10, color: dividerColor),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '재료',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    if (foodData['ingredients'] !=
                        null) // Check if ingredients is not null
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (var ingredient in foodData[
                          'ingredients']!) // Access ingredients with null check
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[300]!,
                                    Colors.grey[200]!,
                                    Colors.white
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                ingredient.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    if (foodData['ingredients'] == null ||
                        foodData['ingredients']!.isEmpty) // Null or empty check
                      Text(
                        'No ingredients available',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ),
            Divider(height: 20, thickness: 10, color: dividerColor),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '요리 레시피:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRecipeList(foodData['recipe']),
              ),
            ),
            const SizedBox(height: 16.0), // Add some bottom padding
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecipeList(List<dynamic>? recipe) {
    List<Widget> widgets = [];
    if (recipe != null) {
      for (var step in recipe) {
        widgets.add(
          ListTile(
            leading: const Icon(Icons.arrow_right),
            title: Text(step),
          ),
        );
      }
    } else {
      widgets.add(const Text('No recipe available'));
    }
    return widgets;
  }
}