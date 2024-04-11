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
  Set<String> selectedIngredients = {};
  Set<String> allIngredients = {};
  List<String> filteredIngredients = []; // 검색 결과를 담을 리스트
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final ingredientsJsonString =
      await rootBundle.loadString('assets/ingredients.json');

      setState(() {
        final List<dynamic> ingredientsData =
        json.decode(ingredientsJsonString);

        // ingredientsData는 리스트 안에 한 개의 맵이므로 이를 고려하여 처리
        if (ingredientsData.isNotEmpty) {
          final Map<String, dynamic> data = ingredientsData.first;
          if (data.containsKey('ingredients')) {
            final List<dynamic> ingredients = data['ingredients'];
            allIngredients.addAll(ingredients.cast<String>());
            filteredIngredients.addAll(ingredients.cast<String>());
          }
        }
      });
    } catch (error) {
      debugPrint('Error loading JSON data: $error');
    }
  }

  // 검색 기능 구현
  void filterIngredients(String query) {
    if (query.isNotEmpty) {
      List<String> tempList = [];
      for (var ingredient in allIngredients) {
        if (ingredient.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(ingredient);
        }
      }
      setState(() {
        filteredIngredients.clear();
        filteredIngredients.addAll(tempList);
      });
      return;
    } else {
      setState(() {
        filteredIngredients.clear();
        filteredIngredients.addAll(allIngredients);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (selectedIngredients.isNotEmpty) {
          return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('선택된 재료가 있습니다. 정말 뒤로 가시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('예',style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('아니오',style: TextStyle(
                      color: Colors.black
                    )),
                  ),
                ],
              );
            },
          ) ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('재료 선택'),
          actions: [
            IconButton(
              onPressed: () {
                // 선택한 재료를 토글하여 FoodCartProvider에 저장
                selectedIngredients.forEach((ingredient) {
                  Provider.of<FoodCartProvider>(context, listen: false).toggleIngredient(ingredient);
                });
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
                        controller: searchController,
                        onChanged: (value) {
                          filterIngredients(value);
                        },
                        decoration: const InputDecoration(
                          hintText: '재료 검색...',
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black), // 원하는 색상 설정
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
                                if (selectedIngredients
                                    .contains(ingredient)) {
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
                                color: selectedIngredients
                                    .contains(ingredient)
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
      ),
    );
  }
}
