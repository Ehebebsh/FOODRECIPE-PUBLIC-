import 'package:flutter/material.dart';
import 'dart:convert' show json;

class CustomSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;

  CustomSearchDelegate(this.context);

  final List<Map<String, dynamic>> _foodData = [];

  Future<void> _loadData() async {
    final List<String> jsonFiles = [
      'assets/koreafood_data.json',
      'assets/westernfood_data.json',
      'assets/chinesefood_data.json',
    ];

    for (final jsonFile in jsonFiles) {
      String data = await DefaultAssetBundle.of(context).loadString(jsonFile);
      List<dynamic> parsedData = json.decode(data);
      _foodData.addAll(
          parsedData.cast<Map<String, dynamic>>()); // Cast to the expected type
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_foodData.isEmpty) {
      _loadData();
    }

    Set<String> uniqueNames = {}; // 중복을 방지하기 위한 Set

    final List<Map<String, dynamic>> suggestionList = query.isEmpty
        ? []
        : _foodData.where((food) {
      if (food['name'].toLowerCase().contains(query.toLowerCase())) {
        return uniqueNames.add(
            food['name']); // 중복된 이름이 없으면 true를 반환하여 해당 음식을 suggestionList에 포함시킴
      } else {
        return false;
      }
    }).toList();

    return ListView(
      children: suggestionList.map((food) {
        return ListTile(
          title: Text(food['name']),
          subtitle: Text(food['tags'].join(', ')),
          leading: Image.network(food['image']),
          onTap: () {
            // Handle suggestion tap
          },
        );
      }).toList(),
    );
  }
}
