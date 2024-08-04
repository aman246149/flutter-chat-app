import 'package:brandzone/core/data/network/api_client.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<dynamic> getUser() async {
    try {
      return await _apiClient.get("/user/getUser");
    } catch (e) {
      rethrow;
    }
  }

  //get All Users
  Future<dynamic> getAllUsers() async {
    try {
      return await _apiClient.get("/user/getAllUsers");
    } catch (e) {
      rethrow;
    }
  }
}
