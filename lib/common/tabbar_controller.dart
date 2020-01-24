import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TabBarController extends StatelessWidget {
  TabBarController(this.pages, this.items);
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;
  final BehaviorSubject<int> pageIndex = BehaviorSubject.seeded(0);

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