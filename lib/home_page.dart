import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_demo1/favorite_page.dart';
import 'package:flutter_demo1/word_bloc.dart';
import 'package:flutter_demo1/word_provider.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final wordBloc = WordProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.of(context).pushNamed(FavoritePage.routeName),
          )
        ],
      ),
      body: _buildListView(wordBloc),
    );
  }

  Widget _buildListView(WordBloc wordBloc) => ListView.builder(
      itemCount: wordBloc.suggestions.length * 2,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
        // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
//          if (index >= _suggestions.length) {
//            // ...接着再生成10个单词对，然后添加到建议列表
//            _suggestions.addAll(generateWordPairs().take(10));
//          }
        return _buildRow(wordBloc, wordBloc.suggestions[index]);
      });

  Widget _buildRow(WordBloc wordBloc, WordPair pair) {
    final bool alreadySaved = wordBloc.saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: wordBloc.biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            wordBloc.saved.remove(pair);
          } else {
            wordBloc.saved.add(pair);
          }
        });
      },
    );
  }
}
