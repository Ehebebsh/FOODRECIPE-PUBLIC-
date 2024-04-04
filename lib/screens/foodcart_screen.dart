import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';

import 'package:foodrecipe/screens/foodcartadd_screen.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({Key? key}) : super(key: key);

  @override
  FoodCartPageState createState() => FoodCartPageState();
}

String addParticle(String word) {
  final lastChar = word.codeUnits.last;
  var hasJongSung = (lastChar - 44032) % 28 > 0;
  return hasJongSung ? '이' : '가';
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
          List<String> selectedIngredients =
          foodCartProvider.selectedIngredients.toList();
          return ListView.builder(
            itemCount: selectedIngredients.length,
            itemBuilder: (context, index) {
              String ingredient = selectedIngredients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1), // 여기서는 const 사용 가능
                child: DismissibleListItem(
                  ingredient: ingredient,
                  onDismissed: () {
                    foodCartProvider.removeIngredient(ingredient);
                    CherryToast.cartdelete(
                      animationType: AnimationType.fromTop,
                      title: Text('$ingredient${addParticle(ingredient)} 삭제되었습니다.'), // 여기서는 const 제거
                    ).show(context);
                  },
                ),
              );
            },
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
            CustomPageRoute(builder: (context) => const FoodCartAddPage()),
          ).then((_) {});
        },
        backgroundColor: Colors.grey[100],
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class DismissibleListItem extends StatelessWidget {
  final String ingredient;
  final VoidCallback onDismissed;

  const DismissibleListItem({
    required this.ingredient,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dismissible 위젯 대신 Container 사용
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // 배경색 설정
        borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게 처리
      ),
      child: ListTile(
        title: Text(ingredient),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDismissed, // 삭제 버튼 클릭 시 onDismissed 콜백 실행
        
        
        ),
        
      ),
    );
  }
}


