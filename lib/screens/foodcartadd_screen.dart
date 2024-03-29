import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';

class FoodCartAddPage extends StatefulWidget {
  const FoodCartAddPage({Key? key}) : super(key: key);

  @override
  FoodCartAddPageState createState() => FoodCartAddPageState();
}

class FoodCartAddPageState extends State<FoodCartAddPage> {
  List<dynamic> allFoodData = [];
  Set<String> selectedIngredients = {};
  Set<String> allIngredients = {};

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final chineseJsonString =
          await rootBundle.loadString('assets/chinesefood_data.json');
      final koreanJsonString =
          await rootBundle.loadString('assets/koreafood_data.json');
      final westernJsonString =
          await rootBundle.loadString('assets/westernfood_data.json');

      setState(() {
        allFoodData.addAll(json.decode(chineseJsonString));
        allFoodData.addAll(json.decode(koreanJsonString));
        allFoodData.addAll(json.decode(westernJsonString));

        for (var item in allFoodData) {
          final ingredients = item['ingredients'] as List?;
          if (ingredients != null) {
            allIngredients.addAll(ingredients.cast<String>());
          }
        }
      });
    } catch (error) {
      debugPrint('Error loading JSON data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 화면의 가로 크기를 얻습니다.
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 선택'),
        actions: [
          IconButton(
            onPressed: () {
              // Provider를 사용하여 선택된 재료 목록을 업데이트합니다.
              // 예시 코드이므로 실제 Provider 사용 방법과 다를 수 있습니다.
              Provider.of<FoodCartProvider>(context, listen: false)
                  .setSelectedIngredients(selectedIngredients);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth - 16, // 좌우 패딩을 고려하여 가로 크기를 설정합니다.
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '선택된 재료',
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedIngredients
                          .map(
                            (ingredient) => Chip(
                          label: Text(ingredient),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              selectedIngredients.remove(ingredient);
                            });
                          },
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: screenWidth - 16, // 여기서도 동일하게 가로 크기를 설정합니다.
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '재료 선택',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: allIngredients.length,
                      itemBuilder: (context, index) {
                        var ingredient = allIngredients.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIngredients.contains(ingredient)) {
                                selectedIngredients.remove(ingredient);
                              } else {
                                selectedIngredients.add(ingredient);
                              }
                            });
                          },
                          child: ListTile(
                            title: Text(ingredient),
                            trailing: Icon(
                              selectedIngredients.contains(ingredient)
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: selectedIngredients.contains(ingredient)
                                  ? Colors.green
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}