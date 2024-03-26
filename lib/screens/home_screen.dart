import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/category_button_widget.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';
import '../widgets/custom_search_delegate_widget.dart';
import 'foodrecipemenu_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _bannerIndex = 0;
  List<String> imageUrls = [];
  List<String> pageTexts = ['오늘의 \n추천요리!', '내일의 \n추천요리!', 'ajrw \n추천요리!'];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadImageUrlsFromJson();
  }

  @override
  void dispose() {
    // 페이지 컨트롤러 해제
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadImageUrlsFromJson() async {
    List<String> urls = [];

    List<String> jsonFiles = [
      'assets/koreafood_data.json',
      'assets/chinesefood_data.json',
      'assets/westernfood_data.json',
    ];

    for (String jsonFile in jsonFiles) {
      String jsonData =
          await DefaultAssetBundle.of(context).loadString(jsonFile);

      List<dynamic> jsonList = json.decode(jsonData);

      urls.addAll(jsonList.map<String>((json) => json['image']).toList());
      _pageController = PageController(initialPage: 0);
    }

    Random random = Random();
    imageUrls = [
      urls[random.nextInt(urls.length)],
      urls[random.nextInt(urls.length)],
      urls[random.nextInt(urls.length)],
    ];

    setState(() {});
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _bannerIndex == index ? 8 : 8,
      decoration: BoxDecoration(
        color: _bannerIndex == index
            ? const Color.fromRGBO(190, 228, 157, 1)
            : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  String _buildText(int index) {
    if (index < pageTexts.length) {
      return pageTexts[index];
    } else {
      return pageTexts.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.all(3),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/logo.JPG'),
            backgroundColor: Colors.transparent,
          ),
        ),
        title: InkWell(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(context),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '오늘의 레시피를 검색해보세요!',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (imageUrls.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imageUrls[index],
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          _bannerIndex = index;
                        });
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          imageUrls.length,
                          (index) => _buildDot(index),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        _buildText(_bannerIndex),
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '요리 종류',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '한식',
                  jsonFileNames: const ['koreafood_data'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FoodPage(
                                title: '한식',
                                jsonFileNames: ['koreafood_data'],
                              )),
                    );
                  },
                ),
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '중식',
                  jsonFileNames: const ['chinesefood_data'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FoodPage(
                                title: '중식',
                                jsonFileNames: ['chinesefood_data'],
                              )),
                    );
                  },
                ),
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '양식',
                  jsonFileNames: const ['westernfood_data'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FoodPage(
                                title: '양식',
                                jsonFileNames: ['westernfood_data'],
                              )),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '손쉽게 할 수 있는 요리',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 120,
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '당신의 요리 솜씨를 뽐내보세요!',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 120,
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
    );
  }
}
