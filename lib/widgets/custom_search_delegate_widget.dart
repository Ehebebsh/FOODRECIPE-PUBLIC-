import 'package:flutter/material.dart';
import 'dart:convert' show json;

import 'package:foodrecipe/screens/food_detail_screen.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;

  CustomSearchDelegate(this.context)
      : super(
          searchFieldLabel: '요리를 검색해보세요!',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          searchFieldDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 20),
          ),
        );

  final List<Map<String, dynamic>> _foodData = [];
  bool _isDataLoaded = false; // 데이터 로딩 상태를 관리하는 변수

  Future<void> _loadData() async {
    if (!_isDataLoaded) {
      // 데이터가 아직 로드되지 않았다면 로드 진행
      final List<String> jsonFiles = [
        'assets/koreafood_data.json',
        'assets/westernfood_data.json',
        'assets/chinesefood_data.json',
      ];

      for (final jsonFile in jsonFiles) {
        String data = await DefaultAssetBundle.of(context).loadString(jsonFile);
        List<dynamic> parsedData = json.decode(data);
        _foodData.addAll(parsedData.cast<Map<String, dynamic>>());
      }
      _isDataLoaded = true; // 데이터 로딩 완료
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildSuggestionsOrResults();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildSuggestionsOrResults();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildSuggestionsOrResults() {
    Set<String> uniqueNames = {};

    final List<Map<String, dynamic>> suggestionList = query.isEmpty
        ? []
        : _foodData.where((food) {
            if (food['name'].toLowerCase().contains(query.toLowerCase())) {
              return uniqueNames.add(food['name']);
            } else {
              return false;
            }
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final food = suggestionList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          // 각 항목의 여백
          decoration: BoxDecoration(
            color: Colors.grey[200], // 여기서 배경색을 설정합니다.
            borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 처리합니다.
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0), // 이미지 모서리를 둥글게 처리합니다.
              child: Image.asset(
                food['image'],
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
            title: Text(
              food['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(food['tags'].join(', ')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(foodData: food),
                ),
              );
            },
            // ListTile의 내부 여백을 조정합니다.
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          ),
        );
      },
    );
  }
}
