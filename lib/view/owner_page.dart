import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/domain/entity.dart';

class OwnerPage extends StatelessWidget {
  OwnerPage(this.dataSource);
  final RepositoryOwner dataSource;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Owner',
        style: TextStyle(color: Colors.white),
      ),
    ),
    body: Center(
      child: ListTile(
        leading: Image.network(dataSource.avatarUrl),
        title: Text(dataSource.login),
        subtitle: Text(dataSource.url),
      ),
    ),
  );
}