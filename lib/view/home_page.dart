import 'package:flutter/material.dart';
import 'package:flutter_demo1/bloc/repository_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatelessWidget {
  final RepositoryBloc wordBloc = RepositoryBloc();

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
          onPressed: () => Navigator.of(context).pushNamed(FavoritePage.routeName, arguments: wordBloc.favoriteList),
        )
      ],
    ),
    body: _buildListView(),
  );

  Widget _buildListView() => StreamBuilder<void>(
    stream: MergeStream([wordBloc.dataSource.stream]),
    builder: (context, snapshot) => EasyRefresh(
      child: ListView.builder(
        itemCount: wordBloc.dataSource.value.items.length * 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final int index = i ~/ 2;
          return _buildRow(wordBloc.dataSource.value.items[index]);
        }),
      onRefresh: () async => wordBloc.param
        .doOnData((it) => it.page = 1)
        .flatMap((it) => NetworkService.searchRepositories(it))
        .listen((it) => wordBloc.dataSource.add(it)),
      onLoad: () async => wordBloc.param
        .doOnData((it) => it.page++)
        .flatMap((it) => NetworkService.searchRepositories(it))
        .listen((it) => wordBloc.dataSource.add(wordBloc.dataSource.value + it), onError: (it) => wordBloc.param.value.page--),
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
