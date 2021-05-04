import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'layoutEditor.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ImportedColors = AxitoColors();
  bool DarkMode = true;
  TextEditingController appTitleController = TextEditingController()..text = '';
  TextEditingController hostIPController = TextEditingController()..text = '';

  setAppName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('appName', appTitleController.text);
  }
  getAppName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appName = prefs.getString('appName') ?? 'SW Controller';
    appTitleController.text = appName;
  }

  setHostIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('hostIP', hostIPController.text);
  }
  getHostIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String appName = prefs.getString('hostIP') ?? '';
    hostIPController.text = appName;
  }

  clearData() async {
    // Clear APP data
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    // Clear fields
    appTitleController.text = '';
    hostIPController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 47,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: SettingsList(
          lightBackgroundColor: ImportedColors.BdrGet,
          sections: [
            SettingsSection(
              title: 'General',
              tiles: [
                SettingsTile(
                  title: 'Language',
                  subtitle: 'English',
                  leading: Icon(Icons.language),
                ),
                SettingsTile(
                  title: 'Host IP',
                  subtitle: 'Local computer IP.',
                  leading: Icon(Icons.wifi),
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: hostIPController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'Host IP',
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Confirm'),
                            onPressed: () {
                              setHostIP();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    );
                  },
                ),
                SettingsTile(
                  title: 'App title',
                  subtitle: 'Customize the appbar title.',
                  leading: Icon(Icons.text_fields_sharp),
                  onPressed: (context) {
                    getAppName();
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: appTitleController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'App title',
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Confirm'),
                            onPressed: () {
                              setAppName();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    );
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Dark mode',
                  subtitle: 'Switch darkmode on/off.',
                  leading: Icon(Icons.remove_red_eye),
                  switchValue: DarkMode,
                  onToggle: (bool value) {
                    DarkMode = !DarkMode;
                    setState(() {});
                  },
                ),
                SettingsTile(
                  title: 'Monitor size',
                  subtitle: 'The monitor size that images convert to.',
                  leading: Icon(Icons.fit_screen),
                  onPressed: (context) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MonitorSize()));
                  },
                ),
                SettingsTile(
                  title: 'Clear data',
                  subtitle: 'Clear all application data.',
                  leading: Icon(Icons.delete_forever),
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Row(
                          children: [
                            Expanded(
                              child: Text('Are you sure you want to clear all application data?'),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.red
                              ),
                            ),
                            onPressed: () {
                              clearData();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    );
                  },
                )
              ],
            ),
            SettingsSection(
              title: 'Layout',
              tiles: [
                SettingsTile(
                  title: 'Edit',
                  subtitle: 'Fully customize the control layout.',
                  leading: Icon(Icons.edit),
                  onPressed: (context) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PageEdit()));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


class MonitorSize extends StatefulWidget {
  @override
  _MonitorSizeState createState() => _MonitorSizeState();
}

class _MonitorSizeState extends State<MonitorSize> {
  List monitorSizes = [['1x1',32,32],['1x2',64,32],['1x3',96,32],['2x2',64,64],['2x3',96,64],['3x3',96,96],['5x3',160,96]]; // [display name,width,height]

  getMonitorSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('monitorSize') ?? false;
  }

  setMonitorSize(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('monitorSize', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 47,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Monitor Size'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: getMonitorSize(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: monitorSizes.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data == index) {
                    return InkWell(
                      onTap: () {},
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            monitorSizes[index][0],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        setMonitorSize(index);
                        setState(() {});
                      },
                      child: Opacity(
                        opacity: 0.75,
                        child: Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              monitorSizes[index][0],
                              style: TextStyle(
                                fontSize: 17
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
