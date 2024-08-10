import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:localstore/localstore.dart';

import '../../main.dart';
import '../constants/app_constants.dart';
import '../routes/router.dart';
import '../routes/router.gr.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio provideDio(Localstore localstore) {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrl;
//Setting baseUrl
    dio.options.connectTimeout = 60000;
    dio
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.data is FormData) {
            options.headers = {'Content-Type': 'multipart/form-data'};
          }
          handler.next(options);
        },
        // onError:
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // getting token
            log("Getting Token");
            var bearerTokenData =
                await localstore.collection("auth").doc("tokenData").get();
          

            var bearerToken = bearerTokenData?[AppConstants.token];
            if (bearerToken != null) {
              // options.headers.putIfAbsent('X-Auth-Token', () => "$accessToken");

              options.headers["Authorization"] = "Bearer $bearerToken";
              // log("X auth token ${options.headers.containsKey("X-Auth-Token")}");
              log("Authorizations ${options.headers.containsKey("Authorization")}");
              log(options.headers.toString());
            } else {
              log('Auth token is null');
            }

            handler.next(options);
          },
        ),
      )
      ..interceptors
          .add(InterceptorsWrapper(onError: ((DioError e, handler) async {
        log(e.response.toString());
        if (e.response!.data["message"].toString().contains("Invalid token") ||
            (e.response?.statusCode == 401 &&
                e.response!.data["message"].toString().contains(
                        "The user belonging to this token does no longer exist.") ==
                    false) ||
            e.response?.statusCode == 403) {
          final cognitoPlugin =
              Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
          try {
            final session = await cognitoPlugin.fetchAuthSession(
              options: const FetchAuthSessionOptions(forceRefresh: true),
            );

            if (session.isSignedIn) {
              await localstore.collection("auth").doc("tokenData").set({
                AppConstants.token:
                    session.userPoolTokensResult.value.idToken.raw
              });

              final response = await dio.fetch(e.requestOptions);
              handler.resolve(response);
              return;
            } else {
              localstore.collection("auth").doc("tokenData").delete();
              GetIt.I<AppRouter>().replaceAll([const LoginRoute()]);
              handler.next(e);
              return;
            }
          } catch (err) {
            localstore.collection("auth").doc("tokenData").delete();
            GetIt.I<AppRouter>().replaceAll([const LoginRoute()]);

            handler.next(e);
            return;
          }
        }
        if (e.response?.data is String) {
          e.response?.data = {"message": e.response?.data};
        } else if (e.response?.data is! Map) {
          e.response?.data = {
            "message": "Some error occurred. Please try again later."
          };
        }
        logger.e(e);
        handler.next(e);
      })));
    return dio;
  }
}
