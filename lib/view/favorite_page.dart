import 'package:flutter/material.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/database_service.dart';
import 'package:flutter_demo1/widget/repository_cell.dart';
import 'package:rxdart/rxdart.dart';

class FavoritePage extends StatelessWidget {
  static const String routeName = '/favorite';
  BehaviorSubject<List<Repository>> get dataSource => DatabaseService.getInstance().repositories;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Favorite Repository',
        style: TextStyle(color: Colors.white),
      ),
    ),
    body: _buildListView(),
  );

  Widget _buildListView() => StreamBuilder<void>(
    stream: dataSource.stream,
    builder: (context, snapshot) =>  ListView.builder(
      itemCount: dataSource.value.length,
      itemBuilder: (context, index) => RepositoryCell(dataSource.value[index])),
  );
}
