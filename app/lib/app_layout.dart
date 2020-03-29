import 'package:app/activities/explore_page.dart';
import 'package:app/chats/user_chats/user_chats_page.dart';
import 'package:app/shared/res/strings.dart';
import 'package:app/user/profile_visualisation_page.dart';
import 'package:app/user/user_activities_page.dart';
import 'package:flutter/material.dart';



/// This Widget is the main application widget.
class AppLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}



/// TODO(dioul)
///
///
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _selectedIndex = 0;

  var _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ExplorePage(),
      UserChatsPage(),
      UserActivitiesPage(),
      ConnectedUserProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text(Strings.navBarExplore),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(Strings.navBarChats),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text(Strings.navBarMyActivities),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            title: Text(Strings.navBarProfile),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
}