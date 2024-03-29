import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:planb/src/bloc/user_bloc.dart';
import 'package:planb/src/model/user_model.dart';
import 'package:planb/src/ui/constants/constants.dart';
import 'package:planb/src/ui/login_screen.dart';
import 'package:planb/src/utility/validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SignUpValidator {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _uniIdController;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  final GlobalKey<FormState> form_key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  User user;

  @override
  void initState() {
    user = User();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: StreamBuilder(
          stream: userBloc.authStatusStream,
          builder: (context, snapshot) {
            if (snapshot.data == AuthStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        "PlanB",
                      ),
                      centerTitle: true,
                      background: Container(
                        color: backgroundColor,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40)),
                            child: Image.asset(
                              "images/loginBackground.jpg",
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Picture of header
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      // This line removing scroll glow
                      behavior: NoGlowScrollBehavior(),
                      // This widget make form scrollable
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8,
                          ),
                          child: Form(
                            key: form_key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                TextFormField(
                                  autofocus: true,
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return firstnameValidator.isValid(value)
                                        ? null
                                        : notValidFirstnameMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "نام",
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  controller: _firstNameController,
                                  onSaved: (text) {
                                    user.firstName = text;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return lastnameValidator.isValid(value)
                                        ? null
                                        : notValidLastnameMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "نام خانوادگی",
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  controller: _lastNameController,
                                  onSaved: (text) {
                                    user.lastName = text;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return uniIdValidator.isValid(value)
                                        ? null
                                        : notValidUniIdMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "کد دانشجویی",
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  controller: _uniIdController,
                                  onSaved: (text) {
                                    user.studentCode = text;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return emailValidator.isValid(value)
                                        ? null
                                        : notValidEmailMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "ایمیل",
                                  ),
                                  textAlign: TextAlign.right,
                                  controller: _emailController,
                                  onSaved: (text) {
                                    user.email = text;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return usernameValidator.isValid(value)
                                        ? null
                                        : notValidUsernameMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "نام کاربری",
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  controller: _usernameController,
                                  onSaved: (text) {
                                    user.username = text;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  style: Theme.of(context).textTheme.headline1,
                                  validator: (value) {
                                    return passwordValidator.isValid(value)
                                        ? null
                                        : notValidPasswordMessage;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "رمز عبور",
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  obscureText: true,
                                  controller: _passwordController,
                                  onSaved: (text) {
                                    user.password = text;
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                RaisedButton(
                                  child: Text(
                                    "ادامه و تکمیل اطلاعات",
                                    // fixme : theme for in button texts
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  onPressed: () {
                                    if (form_key.currentState.validate()) {
                                      form_key.currentState.save();
                                      _checkForNavigate();
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text("وارد شو",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: secondaryColor)),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      },
                                    ),
                                    Text(
                                      "اکانت داری؟",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkForNavigate() {
    userBloc.signUpNewUser(user);
    userBloc.authStatusStream.first.then((value) {
      if (value == AuthStatus.signedIn) {
        Navigator.of(context).pushReplacementNamed('/edit_profile');
      } else if (value == AuthStatus.signedOut) {
        SnackBar snackBar = SnackBar(
          /*content: StreamBuilder(
              stream: bloc.errorsStream,
              builder: (context, AsyncSnapshot<String> snapshot){

                for(String error in snapshot.data){}
                return Text("");
              },
            ),*/
          content: Text(
            "خطا در ثبت نام! دوباره امتخان کن...",
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.red,
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }
}
