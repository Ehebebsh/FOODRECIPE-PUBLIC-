import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/foodcartadd_screen.dart';
import 'package:foodrecipe/widgets/custom_bottom_navigation_action_widget.dart';


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
      body: SingleChildScrollView(
        // Add your body content here
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
            MaterialPageRoute(builder: (context) => FoodCartAddPage()), // 새로운 페이지로 이동
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
