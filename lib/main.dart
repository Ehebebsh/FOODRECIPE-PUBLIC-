import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/provider/foodcart_provider.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
  KakaoSdk.init(nativeAppKey: "f1be4eee65c1b453e96568a01c0014e6");
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiProvider( // MultiProvider 사용
      providers: [
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => FoodCartProvider()), // 새로운 프로바이더 추가
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}