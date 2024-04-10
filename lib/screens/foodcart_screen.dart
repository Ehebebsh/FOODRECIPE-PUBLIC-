import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/screens/foodcartadd_screen.dart';
import '../api/loginchecker.dart';
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
  bool isLoggedIn = false; // Flag to track login status

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Check login status when the widget initializes
  }

  void checkLoginStatus() async {
    // Assuming you have a method to check login status
    bool loggedIn = await LoginChecker().checkLoginStatus();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: isLoggedIn
          ? Consumer<FoodCartProvider>(
        builder: (context, foodCartProvider, _) {
          List<String> selectedIngredients =
          foodCartProvider.selectedIngredients.toList();
          return selectedIngredients.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '장바구니가 비어있습니다.',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: selectedIngredients.length,
            itemBuilder: (context, index) {
              String ingredient = selectedIngredients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 2, vertical: 1), // 여기서는 const 사용 가능
                child: DismissibleListItem(
                  ingredient: ingredient,
                  onDismissed: () {
                    foodCartProvider.removeIngredient(ingredient);
                    CherryToast.cartdelete(
                      animationType: AnimationType.fromTop,
                      title: Text(
                          '$ingredient${addParticle(ingredient)} 삭제되었습니다.'), // 여기서는 const 제거
                    ).show(context);
                  },
                ),
              );
            },
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '로그인을 하고 장바구니를 이용해보세요!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 로그인 버튼 눌렀을 때 로그인 기능 구현
                // 예시: Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute(
                      builder: (context) => const FoodCartAddPage()),
                ).then((_) {});
              },
              backgroundColor: Colors.grey[100],
              child: const Icon(
                Icons.add,
              ),
            )
          : null, // Hide FAB if not logged in
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
