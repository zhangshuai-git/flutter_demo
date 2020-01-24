import 'package:flutter/material.dart';
import 'package:flutter_demo1/bloc/repository_bloc.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/widget/repository_cell.dart';
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
    ),
    body: _buildListView(),
  );

  Widget _buildSearchBar() => TextField(
    controller: textEditingController,
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

  Widget _buildListView() => StreamBuilder<Repositories>(
    stream: repositoryBloc.dataSource.stream,
    builder: (context, snapshot) {
      if (repositoryBloc.dataSource.value.items.length == 0) {
        return Center(
          child: Text("请输入关键字\n实时搜索GitHub上的repositories\n下拉列表刷新数据，上拉加载更多数据\n点击条目查看作者信息\n点击❤️收藏条目(存入数据库)")
        );
      } else {
        return EasyRefresh(
          child: ListView.builder(
            itemCount: repositoryBloc.dataSource.value.items.length,
            itemBuilder: (context, index) =>
              RepositoryCell(repositoryBloc.dataSource.value.items[index])),
          onRefresh: () async => onRefresh.add(textEditingController.text),
          onLoad: () async => onLoad.add(textEditingController.text),
        );
      }
    },
  );
}
