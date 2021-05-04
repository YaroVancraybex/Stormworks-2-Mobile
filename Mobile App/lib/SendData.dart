import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// Configuration 1: 2 joysticks.
// Left vertical  : AXIS 1
// Left horizontal: AXIS 2
// Right vertical  : AXIS 3
// Right horizontal: AXIS 4

String hostIP;

getHostIP() async {
  if (hostIP == null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hostIP = prefs.getString('hostIP') ?? '192.168.0.127';
  }
  return hostIP;
}

sendJoystickData(double degrees, double distanceFromCenter, int joystickSide) async {
  // joystickSide 1 = Left
  // joystickSide 2 = Right

  double radians = degrees * pi / 180;
  dynamic verticalAxis = cos(radians) * distanceFromCenter;
  dynamic horizontalAxis = sin(radians) * distanceFromCenter;
  String host = await getHostIP();

  var reply = await http.post(
    Uri.parse('http://'+host+'/post.php'),
    body: {'type' : 'joystick', 'side' : joystickSide.toString(), 'horizontalAxis' : horizontalAxis.toString(), 'verticalAxis' : verticalAxis.toString()}
  );
}

sendButtonData(bool state, int compositeChannel) async {
  String host = await getHostIP();
  String buttonState;
  if (state == false) {
    buttonState = '1';
  } else {
    buttonState = '0';
  }

  var reply = await http.post(
      Uri.parse('http://'+host+'/post.php'),
      body: {'type' : 'button', 'channel' : compositeChannel.toString(), 'state' : buttonState}
  );
}

sendSliderData(double value, int compositeChannel) async {
  String host = await getHostIP();

  var reply = await http.post(
      Uri.parse('http://'+host+'/post.php'),
      body: {'type' : 'slider', 'channel' : compositeChannel.toString(), 'value' : value.toString()}
  );
}