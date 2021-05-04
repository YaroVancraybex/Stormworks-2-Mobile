import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'SendData.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirstControlPage extends StatefulWidget {
  @override
  _FirstControlPageState createState() => _FirstControlPageState();
}

class _FirstControlPageState extends State<FirstControlPage> {
  final ImportedColors = AxitoColors();
  List buttonStates = [];
  List sliderValues = [];

  getLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var widgets = [];
    dynamic layout = prefs.getString('layout') ?? false;

    if (layout != false) {
      layout = layout.split(',');
      for (var item in layout) {
        item = item.split(':');

        if (item[0] == 'button') {
          widgets.add(
              new FlatButton(
                onPressed: () {},
                child: Text(item[1]),
              )
          );
        }
      }
      return layout;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.of(context).orientation==Orientation.portrait ? Column(
        children: [
          JoystickView(
              size: 210,
              interval: Duration(milliseconds: 100),
              showArrows: true,
              onDirectionChanged: (double degrees, double distanceFromCenter) {
                sendJoystickData(degrees, distanceFromCenter, 1);
              }
          ),
          Expanded(
            child: FutureBuilder(
              future: getLayout(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    return Center(
                      child: Text(
                        'Empty layout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                    );
                  } else {
                    bool addNew;
                    if (buttonStates.length == 0 || sliderValues.length == 0) {
                      addNew = true;
                    } else {
                      addNew = false;
                    }
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ListView.builder(
                        itemCount: snapshot.data.length-1,
                        // ignore: missing_return
                        itemBuilder: (context, index) {
                          final item = snapshot.data[index].split(':');

                          var selectedType = (snapshot.data[index].split(':'))[0];
                          var compositeChannel = 1;
                          var counter = 0;

                          for (var item in snapshot.data) {
                            if (counter == index) {
                              break;
                            }
                            if (item.split(':')[0] == selectedType) {
                              compositeChannel++;
                            }
                            counter++;
                          }

                          if (item[0] == 'button') {
                            if (addNew == true) {
                              buttonStates.add(true);
                            }
                            return OutlinedButton(
                              child: Text(
                                item[1],
                                style: TextStyle(
                                  color: buttonStates[compositeChannel-1] ? Colors.red : ImportedColors.SidebarWestEast,
                                ),
                              ),
                              onPressed: () {
                                buttonStates[compositeChannel-1] = !buttonStates[compositeChannel-1];
                                sendButtonData(buttonStates[compositeChannel-1], compositeChannel);
                                setState(() {});
                              },
                            );
                          } else if (item[0] == 'slider') {
                            if (addNew == true) {
                              sliderValues.add(0);
                            }
                            return Slider(
                              value: double.parse(sliderValues[compositeChannel-1].toString()),
                              onChanged: (double newValue) {
                                sliderValues[compositeChannel-1] = newValue;
                                setState(() {});
                                sendSliderData(newValue, compositeChannel);
                              },
                              divisions: 4,
                              label: item[1],
                            );
                          }
                        },
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          JoystickView(
              size: 210,
              interval: Duration(milliseconds: 100),
              showArrows: true,
              onDirectionChanged: (double degrees, double distanceFromCenter) {
                sendJoystickData(degrees, distanceFromCenter, 1);
              }
          )
        ],
      ) : Row(
        children: [
          JoystickView(
              size: 210,
              interval: Duration(milliseconds: 100),
              showArrows: true,
              onDirectionChanged: (double degrees, double distanceFromCenter) {
                sendJoystickData(degrees, distanceFromCenter, 1);
              }
          ),
          Padding(padding: EdgeInsets.only(left: 200),),
          Expanded(
            child: FutureBuilder(
              future: getLayout(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == false) {
                    return Center(
                      child: Text(
                        'Empty layout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                    );
                  } else {
                    bool addNew;
                    if (buttonStates.length == 0 || sliderValues.length == 0) {
                      addNew = true;
                    } else {
                      addNew = false;
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length-1,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index].split(':');

                        var selectedType = (snapshot.data[index].split(':'))[0];
                        var compositeChannel = 1;
                        var counter = 0;

                        for (var item in snapshot.data) {
                          if (counter == index) {
                            break;
                          }
                          if (item.split(':')[0] == selectedType) {
                            compositeChannel++;
                          }
                          counter++;
                        }

                        if (item[0] == 'button') {
                          if (addNew == true) {
                            buttonStates.add(true);
                          }
                          return OutlinedButton(
                            child: Text(
                              item[1],
                              style: TextStyle(
                                color: buttonStates[compositeChannel-1] ? Colors.red : ImportedColors.SidebarWestEast,
                              ),
                            ),
                            onPressed: () {
                              buttonStates[compositeChannel-1] = !buttonStates[compositeChannel-1];
                              sendButtonData(buttonStates[compositeChannel-1], compositeChannel);
                              setState(() {});
                            },
                          );
                        } else if (item[0] == 'slider') {
                          if (addNew == true) {
                            sliderValues.add(0);
                          }
                          return Slider(
                            value: double.parse(sliderValues[compositeChannel-1].toString()),
                            onChanged: (double newValue) {
                              sliderValues[compositeChannel-1] = newValue;
                              setState(() {});
                              sendSliderData(newValue, compositeChannel);
                            },
                            divisions: 4,
                            label: item[1],
                          );
                        }
                      },
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          JoystickView(
            size: 210,
            interval: Duration(milliseconds: 100),
            showArrows: true,
            onDirectionChanged: (double degrees, double distanceFromCenter) {
              sendJoystickData(degrees, distanceFromCenter, 1);
            }
          )
        ],
      ),
    );
  }
}
