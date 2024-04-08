import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';

import 'package:foodrecipe/screens/foodcartadd_screen.dart';
import '../models/dismissiblelistitem_model.dart';
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
        child: const Icon(Icons.add,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}



