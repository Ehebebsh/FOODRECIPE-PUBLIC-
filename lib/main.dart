import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodrecipe/models/ad_count_provider.dart';
import 'package:foodrecipe/utils/api_key.dart' as cons;
import 'package:foodrecipe/view%20models/foodcart_viewmodel.dart';
import 'package:foodrecipe/view%20models/bookmark_viewmodel.dart';
import 'package:foodrecipe/models/user_model.dart';
import 'package:foodrecipe/view%20models/user_viewmodel.dart';
import 'package:foodrecipe/views/home_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: 'assets/config/.env');
  MobileAds.instance.initialize();
  runApp(const MyApp());
  KakaoSdk.init(nativeAppKey: cons.nativeAppKey);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MultiProvider( // MultiProvider 사용
      providers: [
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => FoodCartProvider()),
        ChangeNotifierProvider(create: (context) => Counter()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'myfont',
        ),
        home: const HomePage(),
      ),
    );
  }
}