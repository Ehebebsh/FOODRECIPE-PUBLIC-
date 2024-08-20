import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/view%20models/foodcart_viewmodel.dart';
import 'package:provider/provider.dart';

class FoodCartAddPage extends StatefulWidget {
  const FoodCartAddPage({Key? key}) : super(key: key);

  @override
  FoodCartAddPageState createState() => FoodCartAddPageState();
}

class FoodCartAddPageState extends State<FoodCartAddPage> {
  Set<String> selectedIngredients = {};
  List<String> detailIngredients = []; // List로 변경
  List<String> filteredIngredients = []; // 추가: 검색 결과를 담을 리스트

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      // 여러 개의 JSON 파일 경로1212
      List<String> jsonFiles = [
        'assets/koreafood_data.json',
        'assets/westernfood_data.json',
        'assets/chinesefood_data.json',
      ];

      for (String filePath in jsonFiles) {
        final ingredientsJsonString = await rootBundle.loadString(filePath);
        final List<dynamic> foodData = json.decode(ingredientsJsonString);

        // 각 JSON 파일의 데이터 처리
        for (var data in foodData) {
          if (data.containsKey('detail-ingredients')) {
            final List<dynamic> ingredients = data['detail-ingredients'];

            // ingredients에서 ', '을 기준으로 분리하여 두 번째 항목부터 끝까지 detailIngredients에 추가
            for (var ingredient in ingredients) {
              if (ingredient.contains(', ')) {
                detailIngredients.add(ingredient.split(', ')[1]);
              }
            }
          }
        }
      }

      setState(() {
        detailIngredients = detailIngredients.toSet().toList();
        filteredIngredients.addAll(detailIngredients
            .where((ingredient) => !Provider.of<FoodCartProvider>(context, listen: false)
            .selectedIngredients
            .contains(ingredient))); // 이미 추가된 재료를 제외
      });
    } catch (error) {
      debugPrint('Error loading JSON data: $error');
    }
  }
  // 추가: 검색 기능 메서드
  void filterIngredients(String query) {
    if (query.isNotEmpty) {
      List<String> tempList = [];
      for (var ingredient in detailIngredients) {
        if (ingredient.toLowerCase().contains(query.toLowerCase()) &&
            !Provider.of<FoodCartProvider>(context, listen: false)
                .selectedIngredients
                .contains(ingredient)) { // 이미 추가된 재료를 제외
          tempList.add(ingredient);
        }
      }
      setState(() {
        filteredIngredients.clear();
        filteredIngredients.addAll(tempList);
      });
    } else {
      setState(() {
        filteredIngredients.clear();
        filteredIngredients.addAll(detailIngredients.where((ingredient) =>
        !Provider.of<FoodCartProvider>(context, listen: false)
            .selectedIngredients
            .contains(ingredient))); // 이미 추가된 재료를 제외
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 선택'),
        actions: [
          IconButton(
            onPressed: () {
              // 선택한 재료를 FoodCartProvider에 저장
              for (var ingredient in selectedIngredients) {
                Provider.of<FoodCartProvider>(context, listen: false)
                    .toggleIngredient(ingredient);
              }
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
                width: screenWidth - 16,
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
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
                width: screenWidth - 16,
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        filterIngredients(value);
                      },
                      decoration: InputDecoration(
                        labelText: '검색',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredIngredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = filteredIngredients[index];
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
