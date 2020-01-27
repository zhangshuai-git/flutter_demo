import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TabBarController extends StatelessWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;
  final BehaviorSubject<int> pageIndex = BehaviorSubject.seeded(0);

  TabBarController({Key key, @required this.pages, @required this.items}) :
      assert(pages != null), assert(items != null), super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: pageIndex.stream,
    builder: (context, snapshot) => Scaffold(
      body: IndexedStack(
        index: pageIndex.value,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex.value,
        items: items,
        onTap: (index) => pageIndex.add(index),
      ),
    )
  );
}