import 'package:flutter/material.dart';
import 'package:flutter_demo1/bloc/repository_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
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
    repositoryBloc.bind(MergeStream([
      onSearch.stream.debounceTime(Duration(seconds: 1)),
      onRefresh.stream,
    ]), onLoad.stream);
  }

  @override
  void dispose() {
    onSearch.close();
    onRefresh.close();
    onLoad.close();
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
            Icons.star,
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
    autofocus: true,
    onChanged: (text) => onSearch.add(text),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
      suffixIcon: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          textEditingController.clear();
          onSearch.add("");
        },
      ) ,
      contentPadding: EdgeInsets.all(10),
    ),
  );

  Widget _buildListView() => StreamBuilder<void>(
    stream: repositoryBloc.dataSource.stream,
    builder: (context, snapshot) => EasyRefresh(
      child: ListView.builder(
        itemCount: repositoryBloc.dataSource.value.items.length * 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) return Divider();
          final int index = i ~/ 2;
          return _buildRow(repositoryBloc.dataSource.value.items[index]);
        }),
      onRefresh: () async => onRefresh.add(textEditingController.text),
      onLoad: () async => onLoad.add(textEditingController.text),
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
