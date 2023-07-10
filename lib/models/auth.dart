import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDyWmkE9o11bB9dS2ZQ7uVbW8FNLHkCtWg';

  Future<void> signup(String email, String password) async {
    final response = await http.post(Uri.parse(_url),
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));

    print(jsonDecode(response.body));
  }
}
