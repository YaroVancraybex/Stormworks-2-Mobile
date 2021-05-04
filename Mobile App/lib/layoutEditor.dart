import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

class PageEdit extends StatefulWidget {
  @override
  _PageEditState createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  getLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic layout = prefs.getString('layout') ?? false;
    return layout;
  }

  reorderLayout(int oldIndex, int newIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic oldLayout = prefs.getString('layout');

    // Converting the string into a list and re-ordering.
    dynamic newLayout = (oldLayout.substring(0,oldLayout.length - 1)).split(',');
    String savedItem = newLayout[oldIndex];
    newLayout.removeAt(oldIndex);

    if (newIndex > 1) {
      newLayout.insert(newIndex-1,savedItem);
    } else {
      newLayout.insert(newIndex,savedItem);
    }

    // Converting the list back to a string and saving.
    String newLayoutString = '';
    for (var item in newLayout) {
      newLayoutString = newLayoutString+item+',';
    }

    prefs.setString('layout', newLayoutString);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async{
            final wait = await Navigator.push(context, MaterialPageRoute(builder: (context) => LayoutAddMenu()));
            setState(() {});
          },
        ),
        appBar: AppBar(
          toolbarHeight: 47,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Layout Editor'),
        ),
        body: FutureBuilder(
            future: getLayout(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != false) {
                  var loadedLayout = (snapshot.data.substring(0,snapshot.data.length - 1)).split(',');
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) async {
                      final wait = await reorderLayout(oldIndex, newIndex);
                      setState(() {});
                    },
                    children: <Widget>[
                      for (int index = 0; index < loadedLayout.length; index++)
                        ListTile(
                          key: Key(index.toString()),
                          title: Text((loadedLayout[index].split(':'))[1]),
                          trailing: Icon(Icons.drag_handle),
                          onTap: () async {
                            // Calculating the composite channel output
                            var selectedType = (loadedLayout[index].split(':'))[0];
                            var displayName = (loadedLayout[index].split(':'))[1];
                            var compositeChannel = 1;
                            var counter = 0;

                            for (var item in loadedLayout) {
                              if (counter == index) {
                                break;
                              }
                              if (item.split(':')[0] == selectedType) {
                                compositeChannel++;
                              }
                              counter++;
                            }

                            final wait = await Navigator.push(context, MaterialPageRoute(builder: (context) => LayoutEntryEdit(index,compositeChannel,displayName)));
                            setState(() {});
                          },
                        ),
                    ],
                  );
                } else {
                  return Center(child: Text(
                    'Empty layout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  ));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}


class LayoutAddMenu extends StatefulWidget {
  @override
  _LayoutAddMenuState createState() => _LayoutAddMenuState();
}

class _LayoutAddMenuState extends State<LayoutAddMenu> {
  String currentLayout;
  addLayoutOption(String type, String displayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic importedLayout = prefs.getString('layout') ?? '';
    // Each button/indicator/... is separated by a comma. Each property within the entry is separated by a double dot.
    // Example: type:name,type:name,

    currentLayout = importedLayout+type+':'+displayName+',';

    prefs.setString('layout', currentLayout);
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
        title: Text('Layout Editor'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                addLayoutOption('button','New Button');
                Navigator.pop(context);
              },
              child: Container(
                height: 80,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      'Button',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                addLayoutOption('slider','New Slider');
                Navigator.pop(context);
              },
              child: Container(
                height: 80,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      'Slider',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LayoutEntryEdit extends StatelessWidget {
  final int index;
  final int compositeChannel;
  final String displayName;
  const LayoutEntryEdit(this.index,this.compositeChannel,this.displayName);

  saveDisplayName(TextEditingController displayNameController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic oldLayout = prefs.getString('layout');

    // Converting the string into a list and updating displayName.
    dynamic newLayout = (oldLayout.substring(0,oldLayout.length - 1)).split(',');
    List savedItem = newLayout[index].split(':');
    savedItem[1] = displayNameController.text;
    newLayout[index] = savedItem[0]+':'+savedItem[1];

    // Converting the list back to a string and saving.
    String newLayoutString = '';
    for (var item in newLayout) {
      newLayoutString = newLayoutString+item+',';
    }

    prefs.setString('layout', newLayoutString);
  }

  removeItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic oldLayout = prefs.getString('layout');

    // Converting the string into a list and updating displayName.
    dynamic newLayout = (oldLayout.substring(0,oldLayout.length - 1)).split(',');
    newLayout.removeAt(index);

    // Converting the list back to a string and saving.
    String newLayoutString = '';
    for (var item in newLayout) {
      newLayoutString = newLayoutString+item+',';
    }

    prefs.setString('layout', newLayoutString);
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
        title: Text('Layout Editor'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: SettingsList(
          lightBackgroundColor: Color(0xFFE5F2FE),
          sections: [
            SettingsSection(
              title: 'General',
              tiles: [
                SettingsTile(
                  title: 'Display name',
                  subtitle: 'Edit the display name.',
                  leading: Icon(Icons.edit),
                  onPressed: (context) {
                    TextEditingController displayNameController = TextEditingController()..text = displayName;
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        content: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: displayNameController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: 'Display name'
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
                              saveDisplayName(displayNameController);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      )
                    );
                  },
                ),
                SettingsTile(
                  title: 'Composite channel '+compositeChannel.toString(),
                  subtitle: 'The composite channel to send/recieve the data on.',
                  leading: Icon(Icons.radio),
                ),
                SettingsTile(
                  title: 'Delete',
                  subtitle: 'Remove the item from the layout.',
                  leading: Icon(Icons.delete),
                  onPressed: (context) {
                    removeItem();
                    Navigator.pop(context);
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