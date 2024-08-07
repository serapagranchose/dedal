import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:dedal/constants/enum/authentification_enum.dart';
import 'package:dedal/core/datasources/authentification/login_datasource.dart';
import 'package:dedal/core/models/user.dart';

class LoginDataSourceImpl extends LoginDataSource {
  final _controller = StreamController<AuthenticationStatus>();

  @override
  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    String? userToken;

    userToken = GetStorage().read('token');
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('http://52.166.128.133'),
      );
      if (response.statusCode != 200) {
        yield AuthenticationStatus.apiOffline;
        yield* _controller.stream;
        return;
      }
    } catch (e) {
      yield AuthenticationStatus.apiOffline;
      yield* _controller.stream;
      return;
    }

    if (userToken == null) {
      yield AuthenticationStatus.unauthenticated;
      yield* _controller.stream;
      return;
    } else {
      response = await http.get(
        Uri.parse('https://app-api.mypet.fit/profile'),
        headers: {'Authorization': 'Bearer $userToken'},
      );
      if (response.statusCode != 200) {
        await GetStorage().remove('token');
        yield AuthenticationStatus.unauthenticated;
      } else {
        yield AuthenticationStatus.authenticated;
      }
    }

    yield* _controller.stream;
  }

  @override
  Future<User?> signIn(String email, String password) async => http.post(
        Uri.parse('http://52.166.128.133/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-type': 'application/json', 'Accept': '*/*'},
      ).then((result) {
        if (result.statusCode == 202) {
          final user = User.fromJson(jsonDecode(result.body));

          return user;
        }
        return null;
      });

  @override
  Future<bool> signUp(String email, String password) async {
    return await http.post(
      Uri.parse('http://52.166.128.133/signup'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-type': 'application/json', 'Accept': '*/*'},
    ).then((result) {
      if (result.statusCode == 201) {
        return true;
      }
      return false;
    });
  }

  @override
  Future<bool> signUpCode(String email, String code) async {
    return await http.post(
      Uri.parse('http://52.166.128.133/confirm'),
      body: jsonEncode({'email': email, 'code': code}),
      headers: {'Content-type': 'application/json', 'Accept': '*/*'},
    ).then((result) {
      if (result.statusCode == 204) {
        return true;
      }
      return false;
    });
  }

  @override
  Future<bool> unsubscribe(String id, String email) async {
    return await http.post(
      Uri.parse('http://52.166.128.133/unsubscribe'),
      body: jsonEncode({'email': email, 'userId': id}),
      headers: {'Content-type': 'application/json', 'Accept': '*/*'},
    ).then((result) {
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    });
  }
}
