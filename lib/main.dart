import 'package:flutter/material.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_demo1/bloc/word_provider.dart';
import 'view/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WordProvider(
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.lightBlueAccent),
          home: HomePage(),
          routes: <String, WidgetBuilder>{
            FavoritePage.routeName: (context) => FavoritePage()
          },
        ),
      );
}
