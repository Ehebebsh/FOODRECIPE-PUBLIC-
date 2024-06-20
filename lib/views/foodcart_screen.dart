import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/view%20models/foodcart_viewmodel.dart';
import 'package:foodrecipe/models/user_model.dart';
import 'package:foodrecipe/utils/colortable.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';
import '../utils/addparticle_widget.dart';
import '../view models/user_viewmodel.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';
import 'foodcartadd_screen.dart';
import 'login_screen.dart';


class FoodCartPage extends StatefulWidget {
  const FoodCartPage({Key? key}) : super(key: key);

  @override
  FoodCartPageState createState() => FoodCartPageState();
}

class FoodCartPageState extends State<FoodCartPage> {
  int _selectedIndex = 3;
  bool isLoggedIn = false; // Flag to track login status
  final KoreanParticleUtil koreanParticleUtil = KoreanParticleUtil();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<UserViewModel>(context, listen: false).checkLoginStatus(context);
    }); // Check login status when the widget initializes
  }


  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserProvider>(context).user != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: isLoggedIn
          ? Consumer<FoodCartProvider>(
        builder: (context, foodCartProvider, _) {
          List<String> selectedIngredients = foodCartProvider.selectedIngredients.toList();
          // 데이터 로딩 중 표시
          if (foodCartProvider.isLoading) { // isLoading은 FoodCartProvider에 정의된 로딩 상태 변수입니다.
            return Center(child: CircularProgressIndicator(color: selectedcolor1,)); // 로딩 인디케이터 표시
          }
          // 장바구니가 비어 있을 경우에 대한 처리
          if (selectedIngredients.isEmpty) {
            return Center(
              child: Text('장바구니가 비어있습니다.',style: TextStyle(fontSize: 18)),
            );
          }
          // 장바구니에 항목이 있는 경우
          return ListView.builder(
            itemCount: selectedIngredients.length,
            itemBuilder: (context, index) {
              String ingredient = selectedIngredients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: DismissibleListItem(
                  ingredient: ingredient,
                  onDismissed: () {
                    foodCartProvider.removeIngredient(ingredient);
                    CherryToast.cartdelete(
                      animationType: AnimationType.fromTop,
                      title: Text('$ingredient${koreanParticleUtil.addParticle(ingredient)} 삭제되었습니다.'),
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
            Text(
              '로그인을 하고 장바구니를 이용해보세요!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.041, // 화면 너비에 따라 조정
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor: MaterialStateProperty.all<Color>(Colors.green),
                side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(
                    color: selectedcolor1,
                    width: 7.0,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute(builder: (context) =>  const LoginScreen()),
                );
              },
              child: const Text('로그인',style: TextStyle(color: Colors.black)),
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
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }}

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(ingredient),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDismissed,
        ),
      ),
    );
  }
}