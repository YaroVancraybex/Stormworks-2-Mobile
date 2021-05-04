import 'dart:convert';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'dart:io';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final ImportedColors = AxitoColors();
  final picker = ImagePicker();
  List monitorSizes = [['1x1',32,32],['1x2',64,32],['1x3',96,32],['2x2',64,64],['2x3',96,64],['3x3',96,96],['5x3',160,96]]; // [display name,width,height]
  File _image;
  File croppedImage;
  String hostIP;
  String base64Image;
  String fileName;
  int monitorSizesIndex;

  getMonitorSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    monitorSizesIndex = prefs.getInt('monitorSize') ?? 1;
  }

  Future getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      fileName = pickedImage.path.split('/').last;
      await cropImage();
    }

    setState(() {});
  }

  Future<File> cropImage() async {
    await getMonitorSize();
    print(monitorSizes[monitorSizesIndex][1]);

    croppedImage = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatio: CropAspectRatio(ratioX: ((monitorSizes[monitorSizesIndex][1]) / (monitorSizes[monitorSizesIndex][2])), ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square]
    );
  }

  uploadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hostIP = prefs.getString('hostIP') ?? '192.168.0.127';
    base64Image = base64Encode(croppedImage.readAsBytesSync());

    print('POST sent to: '+'http://' + hostIP + '/postImage.php');
    final response = await http.post(
      Uri.parse('http://' + hostIP + '/postImage.php'),
      body: {
        "image":base64Image,
        "name":fileName,
        "width":monitorSizes[monitorSizesIndex][1].toString(),
        "height":monitorSizes[monitorSizesIndex][2].toString()
      }
    );
    print(response.statusCode);
    print(response.body);
    print(fileName);
    _image = null;
    croppedImage = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              child: Text(
                'Pick image',
                style: TextStyle(
                  color: ImportedColors.SidebarWestEast,
                  fontSize: 22
                ),
              ),
              onPressed: () {
                getImage();
              },
            ),
          ),
          _image == null || croppedImage == null ? Text('') :
          Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Column(
              children: [
                Image.file(croppedImage),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          size: 35.0,
                          color: ImportedColors.SidebarWestEast,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          uploadImage();
                        },
                      ),
                      RawMaterialButton(
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 35.0,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          _image = null;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            'Pro tip: it is recommended to not upload too big of an image because it can take a while.',
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 20))
        ],
      ),
    );
  }
}