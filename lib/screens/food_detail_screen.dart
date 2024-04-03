import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const FoodDetailPage({Key? key, required this.foodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
            ),
            expandedHeight: 250,
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(foodData['image']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ),


          SliverPadding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodData['name'],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    if (foodData['description'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var desc in foodData['description'])
                            Text(desc.toString()),
                        ],
                      ),
                    if (foodData['description'] == null ||
                        foodData['description'].isEmpty)
                      const Text(
                        'No description available',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(4.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '재료',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    if (foodData['detail-ingredients'] != null)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (var ingredient in foodData['detail-ingredients']!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // 회색 배경색 적용
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                ingredient.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    if (foodData['detail-ingredients'] == null ||
                        foodData['detail-ingredients']!.isEmpty)
                      const Text(
                        'No ingredients available',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(4.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '요리 레시피:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRecipeList(foodData['recipe']),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(4.0),
            sliver: SliverToBoxAdapter(
              child: SizedBox(height: 16.0), // Add some bottom padding
            ),
          ),
        ],
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
