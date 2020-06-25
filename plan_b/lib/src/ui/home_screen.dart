import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planb/src/bloc/authenticatin_bloc.dart';
import 'package:planb/src/bloc/user_bloc.dart';
import 'package:planb/src/ui/complete_profile_screen.dart';
import 'package:planb/src/ui/constants/constants.dart';
import 'package:planb/src/ui/homeTabs/doneProject_tab_created.dart';
import 'package:planb/src/ui/homeTabs/doneProject_tab_takePart.dart';
import 'package:planb/src/ui/homeTabs/goingProject_tab.dart';
import 'package:planb/src/ui/homeTabs/searchProject_tab.dart';
import 'package:planb/src/ui/uiComponents/round_icon_avatar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        endDrawer: _buildEndDrawer(),
        appBar: AppBar(
          title: Text(
            'پروژه ها',
          ),
          bottom: TabBar(
            isScrollable: false,
            tabs: <Widget>[
              _buildTabName(context, 'ساخته شده'),
              _buildTabName(context, 'شرکت داشتی'),
//              _buildTabName(context, 'در حال انجام'),
              _buildTabName(context, 'جستوجو'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DoneProjectsTabCreated(),
            DoneProjectsTabTakePart(),
//            GoingProjectsTab(),
            SearchProjectTab(),
          ],
        ),
      ),
    );
  }

  Padding _buildTabName(BuildContext context, String name) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        name,
        style: TextStyle(
            fontFamily: 'yekan',
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildSolidCircle(double radius, Color color) {
    return ClipOval(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        color: color,
      ),
    );
  }

  Widget _buildListTile(String title, IconData iconData, String destinationPath) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: ListTile(
          onTap: () {
            if(destinationPath == '/login'){
              authenticationBloc.logOut();
            }
            Navigator.pushNamed(context, destinationPath);
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          trailing: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildEndDrawer() {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "نام",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "نام خانوادگی",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                          child: Image.asset(
                            "images/noImage.png",
                            fit: BoxFit.cover,
                            width: 95.0,
                            height: 95.0,
                          )),
                    ),
                  ],
                ),
              ),
              _buildListTile("پروژه جدید", Icons.insert_drive_file, '/home'),
              _buildListTile("پروفایل", Icons.person, '/edit_profile'),
              _buildListTile("درباره ما", Icons.info_outline, '/home'),
              _buildListTile("خروج", Icons.exit_to_app, '/login'),
            ],
          ),
        ),
      ),
    );
  }
}
