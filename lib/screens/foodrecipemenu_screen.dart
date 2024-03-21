import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final String title;
  final String jsonFileName;

  const FoodPage({Key? key, required this.title, required this.jsonFileName}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {


  @override
  Widget build(BuildContext context) {
    var favoritesProvider = Provider.of<BookMarkProvider>(context);
    var favorites = favoritesProvider.favorites;


    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/${widget.jsonFileName}.json'),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> foodList = json.decode(snapshot.data.toString());

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: ListView.builder(
              itemCount: foodList.length * 2 - 1, // 아이템과 선을 고려하여 개수 조정
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  // 인덱스가 홀수인 경우 선을 반환
                  return const Divider();
                }

                var foodIndex = index ~/ 2; // 실제 음식 아이템의 인덱스 계산
                var food = foodList[foodIndex];
                List<String> tags = (food['tags'] as List<dynamic>).cast<String>(); // 'tags' 필드를 명시적으로 List<String>으로 캐스팅
                bool isFavorite = favorites.contains(food['name']); // 즐겨찾기 목록에 해당 음식이 있는지 확인

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          debugPrint('Food tapped: ${food['name']}');
                          // 음식 상세 페이지로 이동하는 코드를 추가할 수 있습니다.
                        },
                        child: Image.network(
                          food['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food['name'],
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              favoritesProvider.toggleFavorite(food['name']);

                            },
                            child:Icon(
                              isFavorite ? Icons.star : Icons.star_border_outlined,
                              color: isFavorite ? Colors.yellow : Colors.yellow, // outlined 아이콘의 색상을 노란색으로 설정
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        tags.join(', '),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
