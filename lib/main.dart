import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:foodrecipe/screens/home_screen.dart';


void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return ChangeNotifierProvider(
      create: (_) => BookMarkProvider(),
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