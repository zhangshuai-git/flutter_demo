
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


}