import 'package:brandzone/core/data/network/api_client.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  //createGroup

  Future<dynamic> createGroup(Map data) async {
    try {
      return await _apiClient.post("/chat/createGroup", data: data);
    } catch (e) {
      rethrow;
    }
  }

  //getGroup

  Future<dynamic> getGroup() async {
    try {
      return await _apiClient.get("/chat/getGroup");
    } catch (e) {
      rethrow;
    }
  }

  //getMessages by groupId

  Future<dynamic> getMessages(String groupId) async {
    try {
      return await _apiClient
          .get("/chat/getMessages", queryParameters: {"groupId": groupId});
    } catch (e) {
      rethrow;
    }
  }
}
