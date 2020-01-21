
import 'package:flutter_demo1/model/entity.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryBloc {
  final BehaviorSubject<Repositories> dataSource = BehaviorSubject.seeded(Repositories());

  final BehaviorSubject<RepositoriesParams> param = BehaviorSubject.seeded(RepositoriesParams("zs"));

  List<Repository> get favoriteList => dataSource.value.items.where((it) => it.isSubscribed.value).toList();

  void dispose() {
    dataSource.close();
    param.close();
  }
}
