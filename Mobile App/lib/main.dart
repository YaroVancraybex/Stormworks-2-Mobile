import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'FirstControlPage.dart';
import 'SecondControlPage.dart';
import 'colors.dart';
import 'settings.dart';
import 'imagePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImportedColors = AxitoColors();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: ImportedColors.SidebarWestEast, // navigation bar color
        statusBarColor: Colors.black.withOpacity(0),
        statusBarIconBrightness: Brightness.light
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ImportedColors.SidebarWestEast,
        accentColor: ImportedColors.SidebarWestEast,
        scaffoldBackgroundColor: ImportedColors.BdrGet
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showAppBar = true;

  getAppName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appName = prefs.getString('appName') ?? 'SW Controller';
    return appName;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(showAppBar ? Icons.close : Icons.add),
          onPressed: () {
            showAppBar = !showAppBar;
            setState(() {});
          },
        ),
        appBar: showAppBar ? AppBar(
          toolbarHeight: 85,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.settings, color: Colors.white,),
            onPressed: () async {
              final wait = await Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              setState(() {});
            },
          ),
          title: FutureBuilder(
            future: getAppName(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Double Joystick'
                ),
              ),
              Tab(
                child: Text(
                  'Single Joystick'
                ),
              ),
              Tab(
                child: Text(
                  'Send Image'
                ),
              )
            ],
          ),
        ) : null,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: FirstControlPage(),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: SecondControlPage(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ImagePage(),
            )
          ],
        ),
      ),
    );
  }
}