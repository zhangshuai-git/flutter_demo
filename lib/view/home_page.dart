import 'package:flutter/material.dart';
import 'package:flutter_demo1/bloc/repository_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:flutter_demo1/view/favorite_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State<HomePage> {
  final RepositoryBloc repositoryBloc = RepositoryBloc();
  final TextEditingController textEditingController = TextEditingController();
  final BehaviorSubject<String> onSearch = BehaviorSubject.seeded("");
  final BehaviorSubject<String> onRefresh = BehaviorSubject.seeded("");
  final BehaviorSubject<String> onLoad = BehaviorSubject.seeded("");

  @override
  void initState() {
    super.initState();

    MergeStream([
        MergeStream([onSearch.stream, onRefresh.stream])
          .map((it) => RepositoriesParams(it)),
        onLoad
          .doOnData((it) => repositoryBloc.param.value.query = it)
      ])
      .listen((it) => repositoryBloc.param.add(it));


  }

  @override
  void dispose() {
    repositoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      brightness: Brightness.dark,
      title: _buildSearchBar(),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushNamed(FavoritePage.routeName, arguments: repositoryBloc.favoriteList),
        )
      ],
    ),
    body: _buildListView(),
  );

  Widget _buildSearchBar() => TextField(
      controller: textEditingController,
      onChanged: (text) {
        onSearch.add(text);
        repositoryBloc.param.value.query = text;
        repositoryBloc.param.add(repositoryBloc.param.value);
      },
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => textEditingController.clear(),
        ) ,
        contentPadding: EdgeInsets.all(10),
      ),
    );

  Widget _buildListView() => StreamBuilder<void>(
    stream: MergeStream([repositoryBloc.dataSource.stream]),
    builder: (context, snapshot) => EasyRefresh(
      child: ListView.builder(
        itemCount: repositoryBloc.dataSource.value.items.length * 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final int index = i ~/ 2;
          return _buildRow(repositoryBloc.dataSource.value.items[index]);
        }),
      onRefresh: () async => repositoryBloc.param
        .doOnData((it) => it.page = 1)
        .flatMap((it) => NetworkService.searchRepositories(it))
        .listen((it) => repositoryBloc.dataSource.add(it)),
      onLoad: () async => repositoryBloc.param
        .doOnData((it) => it.page++)
        .flatMap((it) => NetworkService.searchRepositories(it))
        .listen((it) => repositoryBloc.dataSource.add(repositoryBloc.dataSource.value + it),
        onError: (it) => repositoryBloc.param.value.page--),
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
