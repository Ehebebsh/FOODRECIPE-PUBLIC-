import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';
import 'package:foodrecipe/screens/foodcartadd_screen.dart';

import '../widgets/custom_bottom_navigation_action_widget.dart';

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({Key? key}) : super(key: key);

  @override
  FoodCartPageState createState() => FoodCartPageState();
}

class FoodCartPageState extends State<FoodCartPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: Consumer<FoodCartProvider>(
        builder: (context, foodCartProvider, _) {
          Set<String> selectedIngredients =
              foodCartProvider.selectedIngredients;
          return ListView(
            children: selectedIngredients
                .map((ingredient) => ListTile(
              title: Text(ingredient),
            ))
                .toList(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodCartAddPage()),
          ).then((_) {
            // 페이지가 닫힌 후에 선택된 재료가 업데이트되었을 경우를 처리
            Provider.of<FoodCartProvider>(context, listen: false)
                .notifyListeners();
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
