import 'dart:async';
import 'dart:convert';

import 'package:planb/src/bloc/bloc.dart';
import 'package:planb/src/model/user_model.dart';
import 'package:planb/src/resource/repository.dart';
import 'package:planb/src/utility/message_exception.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc {
  final repository = Repository();
  PublishSubject<AuthStatus> _authStatusStreamController = PublishSubject();
  PublishSubject<List> _errorsStreamController = PublishSubject();
  PublishSubject<List> _skillsStreamController = PublishSubject();
  PublishSubject<List> _citiesStreamController = PublishSubject();
  PublishSubject<List> _universitiesStreamController = PublishSubject();
  PublishSubject<User> _userInfoStreamController = PublishSubject();
  PublishSubject<User> _resumeStreamController = PublishSubject();
  dynamic _lastStatus;

  UserBloc() {
    _lastStatus = _authStatusStreamController.stream.shareValue();
    _lastStatus.listen(null);
  }

  Stream<AuthStatus> get authStatusStream => _authStatusStreamController.stream;

  Stream<List> get errorsStream => _errorsStreamController.stream;

  Stream<List> get skillsStream => _skillsStreamController.stream;

  Stream<List> get citiesStream => _citiesStreamController.stream;

  Stream<List> get universitiesStream => _universitiesStreamController.stream;

  Stream<User> get userInfoStream => _userInfoStreamController.stream;

  Stream<User> get resumeStream => _resumeStreamController.stream;

  AuthStatus get lastStatus => _lastStatus.value;

  signUpNewUser(User user) async {
    try {
      _authStatusStreamController.sink.add(AuthStatus.loading);
      String token = await repository.getNewToken(user);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", token);
      _authStatusStreamController.sink.add(AuthStatus.signedIn);
    } on MessagedException catch (e) {
      _authStatusStreamController.sink.add(AuthStatus.signedOut);
      Map errorsMap = jsonDecode(e.message);
      List<String> errorsList = List();
      errorsMap.forEach((k, v) => errorsList.add(v.toString()));
      _errorsStreamController.sink.add(errorsList);
    } catch (e) {
      _authStatusStreamController.sink.add(AuthStatus.signedOut);
      _errorsStreamController.addError(e);
    }
  }

  login(String username, String password) async {
    try {
      _authStatusStreamController.sink.add(AuthStatus.loading);
      Map data = await repository.login(username, password);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", data['token']);
      getCompleteProfileFields();
      _authStatusStreamController.sink.add(AuthStatus.signedIn);
    } on MessagedException catch (e) {
      _authStatusStreamController.sink.add(AuthStatus.signedOut);
      Map errorsMap = jsonDecode(e.message);
      List<String> errorsList = List();
      errorsMap.forEach((k, v) => errorsList.add(v.toString()));
      _errorsStreamController.sink.add(errorsList);
    } catch (e) {
      _authStatusStreamController.sink.add(AuthStatus.signedOut);
      _errorsStreamController.addError(e);
    }
  }

  getCompleteProfileFields() async {
    try {
      Map response = await repository.getCompleteProfileFields();
      Map user = response['username'];
      _userInfoStreamController.sink.add(User.fromJson(user));
      List list = response['skills'];
      _skillsStreamController.sink.add(list);
      list = response['Code'];
      _citiesStreamController.sink.add(list);
      list = response['University_name'];
      _universitiesStreamController.sink.add(list);
      _saveUsersInfoInSharedPreferences(User.fromJson(user));
    } on TimeoutException catch (e) {
      _skillsStreamController.addError(e);
      _userInfoStreamController.addError(e);
      _citiesStreamController.addError(e);
      _universitiesStreamController.addError(e);
    }
  }

  completeProfile(User requestUser) async {
    try {
      Map map = await repository.completeProfile(requestUser);
      User user = User.fromJson(map);
      _userInfoStreamController.sink.add(user);
    } on MessagedException catch (e) {
      _errorsStreamController.add([e]);
    } catch (e) {
      _errorsStreamController.addError(e);
    }
  }

  getResume(id) async {
    try {
      User user = await repository.getResume(id);
      _resumeStreamController.sink.add(user);
    } on MessagedException catch (e) {
      _resumeStreamController.addError(e);
    } catch (e) {
      _resumeStreamController.addError(e);
    }
  }

  _saveUsersInfoInSharedPreferences(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('firstName', user.firstName);
    sharedPreferences.setString('lastName', user.lastName);
    sharedPreferences.setInt('id', user.id);
  }

  @override
  void dispose() {
    _skillsStreamController.close();
    _citiesStreamController.close();
    _universitiesStreamController.close();
    _authStatusStreamController.close();
    _errorsStreamController.close();
    _userInfoStreamController.close();
    _resumeStreamController.close();
  }
}

UserBloc userBloc = UserBloc();
