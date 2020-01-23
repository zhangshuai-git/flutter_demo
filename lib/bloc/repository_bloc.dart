import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/database_service.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryBloc {
  final NetworkService _networkService = NetworkService.getInstance();
  final DatabaseService _databaseService = DatabaseService.getInstance();

  final BehaviorSubject<Repositories> dataSource = BehaviorSubject.seeded(Repositories());
  final BehaviorSubject<RepositoriesParams> refreshParam = BehaviorSubject.seeded(RepositoriesParams(""));
  final BehaviorSubject<RepositoriesParams> loadParam = BehaviorSubject.seeded(RepositoriesParams(""));

  List<Repository> get favoriteList => dataSource.value.items
    .where((it) => it.isSubscribed.value)
    .toList();

  void bind(Stream<String> refresh, Stream<String> load) {
    refresh
      .map((it) => RepositoriesParams(it))
      .listen((it) => refreshParam.add(it));

    load
      .doOnData((it) => loadParam.value.query = it)
      .map((it) => loadParam.value)
      .listen((it) => loadParam.add(it));

    final newData = refreshParam
      .skip(2)
      .flatMap((it) => _networkService.searchRepositories(it))
      .doOnData((it) => _databaseService.synchronizeSubscription(it))
      .share();

    final moreData = loadParam
      .skip(2)
      .doOnData((it) => it.page = dataSource.value.currentPage + 1)
      .flatMap((it) => _networkService.searchRepositories(it))
      .doOnData((it) => _databaseService.synchronizeSubscription(it))
      .share();

    newData
      .listen((it) => dataSource.add(it));

    moreData
      .map((it) => dataSource.value + it)
      .listen((it) => dataSource.add(it));

    newData
      .where((it) => it.items.length > 0)
      .listen((it) => dataSource.value.currentPage = 1);

    moreData
      .where((it) => it.items.length > 0)
      .listen((it) => dataSource.value.currentPage++);
  }

  void dispose() {
    dataSource.close();
    refreshParam.close();
    loadParam.close();
  }
}
