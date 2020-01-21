import 'package:flutter/material.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatelessWidget {
//  final WordBloc wordBloc = WordBloc();
//  final BehaviorSubject<void> refreshFinished = BehaviorSubject.seeded(null);
  final BehaviorSubject<Repositories> dataSource = BehaviorSubject.seeded(Repositories());
  List<Repository> get favoriteList => dataSource.value.items.where((it) => it.isSubscribed.value).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      brightness: Brightness.dark,
      title: Text(
        'Startup Name Generator',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushNamed(FavoritePage.routeName, arguments: favoriteList),
        )
      ],
    ),
    body: _buildListView(),
  );

  Widget _buildListView() => StreamBuilder<void>(
    stream: MergeStream([dataSource.stream]),
    builder: (context, snapshot) => EasyRefresh(
      child: ListView.builder(
        itemCount: dataSource.value.items.length * 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final int index = i ~/ 2;
          return _buildRow(dataSource.value.items[index]);
        }),
      onRefresh: () async => NetworkService.searchRepositories("zs").listen((it) => dataSource.add(it)),
      onLoad: () async => NetworkService.searchRepositories("zs").listen((it) => dataSource.add(dataSource.value + it)),
    ),
  );

  Widget _buildRow(final Repository repository) => StreamBuilder<bool>(
    stream: repository.isSubscribed.stream,
    builder: (context, snapshot) => ListTile(
      title: Text(
        repository.name,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        repository.isSubscribed.value ? Icons.favorite : Icons.favorite_border,
        color: repository.isSubscribed.value ? Colors.red : null,
      ),
      onTap: () => repository.isSubscribed.add(!repository.isSubscribed.value),
    ));
}
