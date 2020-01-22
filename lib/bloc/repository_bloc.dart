import 'package:flutter_demo1/model/entity.dart';
import 'package:flutter_demo1/service/network_service.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryBloc {
  final NetworkService networkService = NetworkService.getInstance();

  final BehaviorSubject<Repositories> dataSource = BehaviorSubject.seeded(Repositories());

  final BehaviorSubject<RepositoriesParams> refreshParam = BehaviorSubject.seeded(RepositoriesParams("zs"));

  final BehaviorSubject<RepositoriesParams> loadParam = BehaviorSubject.seeded(RepositoriesParams("zs"));

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

    var newData = refreshParam
      .skip(2)
      .flatMap((it) => networkService.searchRepositories(it))
      .share();

    var moreData = loadParam
      .skip(2)
      .doOnData((it) => it.page = dataSource.value.currentPage + 1)
      .flatMap((it) => networkService.searchRepositories(it))
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
