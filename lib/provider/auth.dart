import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart ' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBs4zqzBZaxeo7_uJkyLp6sWFPwrkXcWhQ";
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));

    //  _outoLogout();
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userDate = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate!.toIso8601String(),
      });

      prefs.setString('userDate', userDate);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userDate')) {
      return false;
    }
    final Map<String, Object> extractedData = json
        .decode(prefs.getString('userDate') as String) as Map<String, Object>;
    final expireDate = DateTime.parse(extractedData['expiryDate'] as String);
    if (expireDate.isBefore(DateTime.now())) return false;
    _token = extractedData['token'] as String;
    _userId = extractedData['userId'] as String;
    _expireDate = expireDate;
    notifyListeners();
    _outoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _outoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
