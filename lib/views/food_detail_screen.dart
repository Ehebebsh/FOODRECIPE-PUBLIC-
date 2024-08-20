import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/view%20models/foodcart_viewmodel.dart';
import '../view models/user_viewmodel.dart'; // UserViewModel import

class FoodDetailPage extends StatefulWidget {
  final Map<String, dynamic> foodData;

  const FoodDetailPage({Key? key, required this.foodData}) : super(key: key);

  @override
  FoodDetailPageState createState() => FoodDetailPageState();
}

class FoodDetailPageState extends State<FoodDetailPage> {
  bool _isButtonPressed = false;
  bool _isLoggedIn = false; // 로그인 상태를 저장하는 변수

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(); // 로그인 상태 확인
    });
  }

  Future<void> _checkLoginStatus() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final isLoggedIn = await userViewModel.checkLoginStatus(context);

    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                      image: AssetImage(widget.foodData['image']),
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
                      widget.foodData['name'],
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    if (widget.foodData['description'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var desc in widget.foodData['description'])
                            Text(desc.toString()),
                        ],
                      ),
                    if (widget.foodData['description'] == null ||
                        widget.foodData['description'].isEmpty)
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '재료',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isLoggedIn) // 로그인 상태에 따라 버튼 표시
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isButtonPressed = true;
                              });

                              final ingredients = widget.foodData['detail-ingredients'] ?? [];
                              final foodCartProvider =
                              Provider.of<FoodCartProvider>(context, listen: false);
                              await foodCartProvider.parseAndSetIngredients(ingredients);

                              CherryToast.success(
                                title: const Text('재료가 장바구니에 추가되었습니다.'),
                                animationType: AnimationType.fromTop,
                              ).show(context);

                              setState(() {
                                _isButtonPressed = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: _isButtonPressed ? Colors.white : Colors.green,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: const Text(
                                '장바구니 추가',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    if (widget.foodData['detail-ingredients'] != null)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (var ingredient in widget.foodData['detail-ingredients']!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                ingredient.toString().split(', ').first,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    if (widget.foodData['detail-ingredients'] == null ||
                        widget.foodData['detail-ingredients']!.isEmpty)
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
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRecipeList(widget.foodData['recipe']),
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
