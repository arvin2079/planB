import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planb/src/bloc/user_bloc.dart';
import 'package:planb/src/model/user_model.dart';
import 'package:planb/src/ui/uiComponents/customTextField.dart';
import 'package:planb/src/ui/uiComponents/round_icon_avatar.dart';
import 'package:planb/src/ui/uiComponents/titleText.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _searchInputController = TextEditingController();
  String _genderTitle = 'جنسیت';
  String _universityTitle = 'دانشگاه';
  UserBloc bloc = UserBloc();
  User user = User();

  List<String> sexItems = <String>['مرد', 'زن'];

  List<String> _chipsData = <String>[];

  List<String> _uniItems = <String>[
    'امیرکبیر',
    'خوارزمی',
    'شریف',
    'مشهد',
    'خواجه نصیر',
  ];

  List<String> _getSearchFieldSuggestion(String data) {
    return <String>[
      'hello',
      'this is apple',
      'android',
      'ios',
      'art',
      'python',
      'front-end',
      'back-end',
      'yellow',
      'arvin',
      'container',
      'flutter',
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تکمیل اطلاعات',
            style: Theme.of(context).textTheme.title,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => LimitedBox(
            maxHeight: double.maxFinite,
            maxWidth: double.maxFinite,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Avatar(
                          icon: Icons.add,
                          iconSize: 30,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // fixme : style for these texts
                            //fixme: user must enter his name, its a static text!
                            Text(
                              'نام',
                              style: Theme.of(context).textTheme.display1,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'نام خوانوادگی',
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    //fixme: university has a dropBox for choose and its useless
                    CustomTextField(labelText: 'نام دانشگاه'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DropdownButton(
                          hint: Text(
                            _genderTitle,
                            style: Theme.of(context).textTheme.display2,
                          ),
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _genderTitle = value;
                            });
                          },
                          items: sexItems.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.display2,
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton(
                          hint: Text(_universityTitle),
                          style: Theme.of(context).textTheme.display2,
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              _universityTitle = value;
                            });
                          },
                          items: _uniItems.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.display2,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    TitleText(text: 'اطلاعات تماس'),
                    CustomTextField(
                      labelText: 'موبایل',
                      inputType: TextInputType.phone,
                      maxLength: 11,
                      hintText: "09123456789",
                      controller: _controller,
                    ),
                    CustomTextField(
                      labelText: 'ایمیل',
                      inputType: TextInputType.emailAddress,
                      hintText: "example@gmail.com",
                    ),
                    CustomTextField(
                      labelText: 'وبسایت',
                      inputType: TextInputType.url,
                      hintText: "www.example.com",
                    ),
                    CustomTextField(labelText: 'اینستاگرام',hintText: "yourID",),
                    CustomTextField(labelText: 'تلگرام',hintText: "yourID",),
                    CustomTextField(labelText: 'گیت',hintText: "yourID",),
                    CustomTextField(labelText: 'لینکدین',hintText: "yourID",),
                    SizedBox(height: 30),
                    TitleText(text: 'اطلاعات تماس'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        style: Theme.of(context).textTheme.display2,
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.display2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          labelText: 'خلاصه ای از سوابغ خود بنویسید',
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TitleText(text: 'مهارت های شما'),
                    _buildSearchTextField(context),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Wrap(
                        children: _chipWidgets.toList(),
                        spacing: 10.0,
                      ),
                    ),
                    RaisedButton(
                      child: Text('ادامه و تکمیل حساب',
                          style: Theme.of(context).textTheme.button),
                      onPressed: () {
                        // get inputs instead of 6 lines below
                        /*user.firstName = "firstName";
                        user.lastName = "lastName";
                        user.username = "username";
                        user.phoneNumber = "9382883937";
                        user.grades = ["1"];
                        user.gender = true;*/

                        bloc.signUpNewUser(user);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildSearchTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: AutoCompleteTextField<String>(
        controller: _searchInputController,
        style: Theme.of(context).textTheme.display3,
        itemSubmitted: (data) {
          setState(() {
            if (!_chipsData.contains(data))
              _chipsData.add(data);
            else {
              // fixme : this part throw an error when i want to show alert snackbar (fixed)
              // solution : This exception happens because you are using the context of the widget that instantiated Scaffold. Not the context of a child of Scaffold.
              // for this we add builder to the Scaffold body so builder parent is scaffold and can be userd via ther context.
              // solution : using globaleKey for the scaffold :
              // _scaffoldKey.currentState.showSnackBar(snackbar);

              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'این مهارت قبلا اضافه شده',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'yekan',
                  ),
                ),
              ));
            }
          });
        },
        suggestions: _getSearchFieldSuggestion(_searchInputController.text),
        key: GlobalKey(),
        itemFilter: (String suggestion, String query) {
          // FIXME : implement itemFilter for search (fixed)
          // using RegExp
          return suggestion.contains(RegExp(r'\b' + '${query.toLowerCase()}'));
        },
        itemSorter: (String a, String b) {
          // FIXME : implement comparator for search
          if (a.length < b.length)
            return -1;
          else
            return 1;
        },
        itemBuilder: (BuildContext context, String suggestion) {
          // FIXME : make style for list item Texts
          return Text(
            suggestion,
            style: Theme.of(context).textTheme.display4,
          );
        },
      ),
    );
  }

  Iterable<Widget> get _chipWidgets sync* {
    for (final String item in _chipsData) {
      yield Chip(
        label: Text(item),
        onDeleted: () {
          setState(() {
            _chipsData.removeWhere((data) {
              return item == data;
            });
          });
        },
      );
    }
  }
}

// fixme : search field item font ROBOTO download
