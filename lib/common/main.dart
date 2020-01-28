import 'package:flutter/material.dart';
import 'package:flutter_demo1/common/tabbar_controller.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_demo1/view/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(primaryColor: Color(0xFFE18996)),
    home: TabBarController(
      pages: [HomePage(), FavoritePage()],
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Container()),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Container())
      ],
    ),
  );
}
