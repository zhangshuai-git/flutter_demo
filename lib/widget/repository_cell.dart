import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/database_service.dart';
import 'package:flutter_demo1/view/owner_page.dart';
import 'package:flutter_demo1/utility/extension.dart';
import 'package:flutter_demo1/model/constant.dart';

class RepositoryCell extends StatelessWidget {
  const RepositoryCell(this.repository, { Key key,}) : super(key: key);
  final Repository repository;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: repository.isSubscribed.stream,
    builder: (context, snapshot) => GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OwnerPage(repository.owner),
      )),
      child: Card(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(repository.name ?? ""),
              subtitle: Text(repository.htmlUrl ?? ""),
              trailing: _buildIconButton(),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(repository.desp ?? ""),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildIconButton() => IconButton(
    icon: Icon(
      repository.isSubscribed.value ? Icons.favorite : Icons.favorite_border,
      color: repository.isSubscribed.value ? Color.fromHex(Constant.colorPrimary) : null,
    ),
    onPressed: () {
      final isSubscribed = !repository.isSubscribed.value;
      final databaseService = DatabaseService.getInstance();
      isSubscribed ? databaseService.add(repository) : databaseService.delete(repository);
      repository.isSubscribed.add(isSubscribed);
    },
  );
}