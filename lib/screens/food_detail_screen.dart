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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
            ),
            expandedHeight: 250,
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 이전 화면으로 이동
              },
            ),
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(foodData['image']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ),


          SliverPadding(
            padding: EdgeInsets.fromLTRB(4, 8, 4, 4),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodData['name'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
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
                      Text(
                        'No description available',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // SliverPadding(
          //   padding: EdgeInsets.all(4.0),
          //   sliver: SliverToBoxAdapter(
          //     child: Wrap(
          //       children: [
          //         for (var tag in foodData['tags'])
          //           Container(
          //             margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
          //             padding: EdgeInsets.symmetric(
          //               horizontal: 12.0,
          //               vertical: 4.0,
          //             ),
          //             decoration: BoxDecoration(
          //               color: Colors.white, // 배경색을 흰색으로 설정
          //               borderRadius: BorderRadius.circular(20.0),
          //             ),
          //             child: Text(
          //               tag,
          //               style: TextStyle(color: Colors.black),
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: EdgeInsets.all(4.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '재료',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    if (foodData['ingredients'] != null)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (var ingredient in foodData['ingredients']!)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // 회색 배경색 적용
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                ingredient.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    if (foodData['ingredients'] == null ||
                        foodData['ingredients']!.isEmpty)
                      Text(
                        'No ingredients available',
                        style: TextStyle(fontSize: 14.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(4.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '요리 레시피:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRecipeList(foodData['recipe']),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
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
            leading: Icon(Icons.arrow_right),
            title: Text(step),
          ),
        );
      }
    } else {
      widgets.add(Text('No recipe available'));
    }
    return widgets;
  }
}
