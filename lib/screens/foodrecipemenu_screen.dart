import 'dart:convert';
import 'package:flutter/material.dart';

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
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/${widget.jsonFileName}.json'),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                  return Divider();
                }

                var foodIndex = index ~/ 2; // 실제 음식 아이템의 인덱스 계산
                var food = foodList[foodIndex];
                List<String> tags = (food['tags'] as List<dynamic>).cast<String>(); // 'tags' 필드를 명시적으로 List<String>으로 캐스팅
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('dd');
                          // 이미지를 클릭했을 때 처리할 작업 추가
                          // 예를 들어 다른 페이지로 이동하는 코드를 여기에 추가할 수 있습니다.
                        },
                        child: Image.network(
                          food['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        food['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        tags.join(', '),
                        style: TextStyle(
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
