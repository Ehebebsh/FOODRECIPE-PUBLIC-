import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:foodrecipe/utils/admob_helper.dart';
import 'package:foodrecipe/provider/ad_count_provider.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';
import '../models/easyandhard_foodimage_model.dart';
import '../utils/api_key.dart';
import '../widgets/category_button_widget.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';
import '../widgets/custom_search_delegate_widget.dart';
import 'food_detail_screen.dart';
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
  List<String> pageTexts = ['오늘의 \n추천요리!', '내일의 \n추천요리!', '엄마의 \n추천요리!'];
  late PageController _pageController;
  late Future<List<dynamic>> easyFoodImagesFuture;
  late Future<List<dynamic>> hardFoodImagesFuture;
  final FoodImageLoader foodImageLoader = FoodImageLoader();

  RewardAdManager adManager = RewardAdManager(rewardAdId: rewardAdId);

  int totalButtonTapCount = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadImageUrlsFromJson();
    easyFoodImagesFuture = foodImageLoader.loadEasyFoodImages(context);
    hardFoodImagesFuture = foodImageLoader.loadHardFoodImages(context);
    adManager.loadAd();
  }

  @override
  void dispose() {
    // 페이지 컨트롤러 해제
    _pageController.dispose();
    super.dispose();
    adManager.dispose();
  }

  Future<void> loadImageUrlsFromJson() async {
    List<String> urls = [];
    List<String> jsonFiles = ['assets/foodimage.json'];

    for (String jsonFile in jsonFiles) {
      String jsonData = await DefaultAssetBundle.of(context).loadString(jsonFile);
      List<dynamic> jsonList = json.decode(jsonData);

      if (jsonList.isNotEmpty) {
        List<dynamic> images = jsonList[0]['image'];
        urls.addAll(images.map<String>((json) => json.toString()).toList());
      }
    }

    Random random = Random();
    Set<String> uniqueUrls = {}; // 중복을 방지하기 위한 Set 사용

    // 이미지 URL을 랜덤하게 선택하고 중복 제거
    while (uniqueUrls.length < 3) {
      String selectedUrl = urls[random.nextInt(urls.length)];
      uniqueUrls.add(selectedUrl);
    }

    // Set을 다시 리스트로 변환하여 imageUrls에 저장
    imageUrls = uniqueUrls.toList();

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

  void checkAndShowAd() {
    // Provider를 통해 Counter 인스턴스에 접근합니다.
    int count = Provider
        .of<Counter>(context, listen: false)
        .count;
    if (count % 7 == 0) {
      adManager.showAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
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
                height: 220,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imageUrls[index],
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                          color: Colors.white,
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
                      fontSize: 17.0,
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
                  image: 'assets/koreanfood_images/food4.jpg',
                  buttonText: '한식',
                  jsonFileNames: const ['koreafood_data'],
                  onPressed: () {
                    Provider.of<Counter>(context, listen: false).increment();
                    checkAndShowAd();

                    Navigator.push(
                      context,
                      CustomPageRoute(
                        builder: (context) =>
                        const FoodPage(
                          title: '한식',
                          jsonFileNames: ['koreafood_data'],
                        ),
                      ),
                    );
                  },
                ),
                CategoryButton(
                  image: 'assets/chinesefood_image/ch1.jpg',
                  buttonText: '중식',
                  jsonFileNames: const ['chinesefood_data'],
                  onPressed: () {
                    Provider.of<Counter>(context, listen: false).increment();
                    checkAndShowAd();
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) =>
                          const FoodPage(
                            title: '중식',
                            jsonFileNames: ['chinesefood_data'],
                          )),
                    );
                  },
                ),
                CategoryButton(
                  image: 'assets/westernfood_image/wes1.jpg',
                  buttonText: '일식/양식',
                  jsonFileNames: const ['westernfood_data'],
                  onPressed: () {
                    Provider.of<Counter>(context, listen: false).increment();
                    checkAndShowAd();
                    Navigator.push(
                      context,
                      CustomPageRoute(
                          builder: (context) =>
                          const FoodPage(
                            title: '양식',
                            jsonFileNames: ['westernfood_data'],
                          )),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '손쉽게 할 수 있는 요리',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Counter>(context, listen: false).increment();
                      checkAndShowAd();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const FoodPage(
                              title: '간단한 요리',
                              jsonFileNames: ['easyfood'],
                            )),
                      );
                    },
                    child: const Text(
                      '더보기',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            FutureBuilder(
              future: easyFoodImagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> easyFoodImages = snapshot.data![0];
                    List<dynamic> easyFoodJsonList = snapshot.data![1];
                    return SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          var foodData =
                          easyFoodJsonList[index] as Map<String, dynamic>;
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Counter>(context, listen: false)
                                        .increment();
                                    checkAndShowAd();
                                    Navigator.push(
                                      context,
                                      CustomPageRoute(
                                        builder: (context) =>
                                            FoodDetailPage(foodData: foodData),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      easyFoodImages[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover, // 이미지를 꽉 차게 표시
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  foodData['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  foodData['tags'] != null
                                      ? foodData['tags']
                                      .sublist(0, 2)
                                      .join(', ')
                                      : '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '당신의 요리 솜씨를 뽐내보세요!',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Counter>(context, listen: false).increment();
                      checkAndShowAd();
                      Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) =>
                            const FoodPage(
                              title: '손이 많이 가는 요리',
                              jsonFileNames: ['hardfood'],
                            )),
                      );
                    },
                    child: const Text(
                      '더보기',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            FutureBuilder(
              future: hardFoodImagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> easyFoodImages = snapshot.data![0];
                    List<dynamic> easyFoodJsonList = snapshot.data![1];
                    return SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          var foodData =
                          easyFoodJsonList[index] as Map<String, dynamic>;
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<Counter>(context, listen: false)
                                        .increment();
                                    checkAndShowAd();
                                    Navigator.push(
                                      context,
                                      CustomPageRoute(
                                        builder: (context) =>
                                            FoodDetailPage(foodData: foodData),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      easyFoodImages[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover, // 이미지를 꽉 차게 표시
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  foodData['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  foodData['tags'] != null
                                      ? foodData['tags']
                                      .sublist(0, 2)
                                      .join(', ')
                                      : '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
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
