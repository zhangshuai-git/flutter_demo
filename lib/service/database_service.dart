import 'package:flutter_demo1/model/entity.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseService {
  static DatabaseService _instance;
  DatabaseService._internal();
  static _getInstance() {
    if (_instance == null) {
      _instance = DatabaseService._internal();
    }
    return _instance;
  }
  factory DatabaseService.getInstance() => _getInstance();

  final BehaviorSubject<List<Repository>> repositories = BehaviorSubject.seeded([]);

  /*
    func add(repository : Repository) {
        Observable<Void>
            .create({ (subscriber) -> Disposable in
                DatabaseAPI.shared.add(repository: repository)
                subscriber.onNext(())
                subscriber.onCompleted()
                return Disposables.create()
            })
            .flatMapLatest {
                self.getAllRepository()
            }
            .bind(to: repositories)
            .disposed(by: disposeBag)
    }

    func delete(repository: Repository) {
        Observable<Void>
            .create({ (subscriber) -> Disposable in
                DatabaseAPI.shared.delete(repository: repository)
                subscriber.onNext(())
                subscriber.onCompleted()
                return Disposables.create()
            })
            .flatMapLatest {
                self.getAllRepository()
            }
            .bind(to: repositories)
            .disposed(by: disposeBag)
    }

    private func getAllRepository() -> Observable<[Repository]> {
        return Observable
            .from(DatabaseAPI.shared.getAllRepository())
            .map({
                $0.isSubscribed = true
                return $0
            })
            .toArray()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
    }
  * */
}