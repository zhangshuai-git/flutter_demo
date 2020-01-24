import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/database_service.dart';

class RepositoryCell extends StatelessWidget {
  const RepositoryCell(this.repository, { Key key,}) : super(key: key);
  final Repository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
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
        onTap: () {
          var isSubscribed = !repository.isSubscribed.value;
          final databaseService = DatabaseService.getInstance();
          isSubscribed ? databaseService.add(repository) : databaseService.delete(repository);
          repository.isSubscribed.add(isSubscribed);
        },
      ));
  }
}