// ignore_for_file: deprecated_member_use, unused_field, unused_element

import 'dart:io';
import 'package:Face_recognition/Screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screens/adminscreen.dart';
import 'utils.dart';
import 'dart:convert';
import 'detector_painters.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';
import 'package:image/image.dart' as imglib;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File jsonFile;
  dynamic _scanResults;
  CameraController _camera;
  var interpreter;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  dynamic data = {};
  double threshold = 1.0;
  Directory tempDir;
  List e1;
  bool _faceFound = false;
  final TextEditingController _name = new TextEditingController();
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  Future loadModel() async {
    try {
      final gpuDelegateV2 = tfl.GpuDelegateV2(
          options: tfl.GpuDelegateOptionsV2(
        false,
        tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
        tfl.TfLiteGpuInferencePriority.minLatency,
        tfl.TfLiteGpuInferencePriority.auto,
        tfl.TfLiteGpuInferencePriority.auto,
      ));

      var interpreterOptions = tfl.InterpreterOptions()
        ..addDelegate(gpuDelegateV2);
      interpreter = await tfl.Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } on Exception {
      print('Failed to load model.');
    }
  }

  void _initializeCamera() async {
    await loadModel();
    CameraDescription description = await getCamera(_direction);

    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _camera =
        CameraController(description, ResolutionPreset.low, enableAudio: false);
    await _camera.initialize();
    await Future.delayed(Duration(milliseconds: 500));
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new File(_embPath);
    if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());

    _camera.startImageStream((CameraImage image) {
      if (_camera != null) {
        if (_isDetecting) return;
        _isDetecting = true;
        String res;
        dynamic finalResult = Multimap<String, Face>();
        detect(image, _getDetectionMethod(), rotation).then(
          (dynamic result) async {
            if (result.length == 0)
              _faceFound = false;
            else
              _faceFound = true;
            Face _face;
            imglib.Image convertedImage =
                _convertCameraImage(image, _direction);
            for (_face in result) {
              double x, y, w, h;
              x = (_face.boundingBox.left - 10);
              y = (_face.boundingBox.top - 10);
              w = (_face.boundingBox.width + 10);
              h = (_face.boundingBox.height + 10);
              imglib.Image croppedImage = imglib.copyCrop(
                  convertedImage, x.round(), y.round(), w.round(), h.round());
              croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
              // int startTime = new DateTime.now().millisecondsSinceEpoch;
              res = _recog(croppedImage);
              // int endTime = new DateTime.now().millisecondsSinceEpoch;
              // print("Inference took ${endTime - startTime}ms");
              finalResult.add(res, _face);
            }
            setState(() {
              _scanResults = finalResult;
            });

            _isDetecting = false;
          },
        ).catchError(
          (_) {
            _isDetecting = false;
          },
        );
      }
    });
  }

  HandleDetection _getDetectionMethod() {
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    return faceDetector.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('');
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );
    painter = FaceDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    if (_camera == null || !_camera.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(child: null)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_camera),
                _buildResults(),
              ],
            ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }
    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Face recognition'),
          leading: IconButton(
              icon: Icon(Icons.add, color: Colors.blue), onPressed: () {}),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (Choice result) {
                // if (result == Choice.delete)
                //   _resetFile();
                // else
                //   _viewLabels();

                if (result == Choice.delete) {
                  _auth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignIn();
                  }));
                } else if (result == Choice.herder) {
                  // setState(() {
                  //   _camera = null;
                  // });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminScreen(),
                    ),
                  );
                }
                // else {
                //   _viewLabels();
                // }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
                // const PopupMenuItem<Choice>(
                //   child: Text('Remove all faces'),
                //   value: Choice.delete,
                // ),
                const PopupMenuItem<Choice>(
                  child: Text('Admin Panel'),
                  value: Choice.herder,
                ),
                // const PopupMenuItem<Choice>(
                //   child: Text('View Saved Faces'),
                //   value: Choice.view,
                // ),
                const PopupMenuItem<Choice>(
                  child: Text('Sign Out'),
                  value: Choice.delete,
                ),
              ],
            ),
          ],
        ),
        body: _buildImage(),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          // FloatingActionButton(
          //   backgroundColor: (_faceFound) ? Colors.blue : Colors.blueGrey,
          // child: Icon(Icons.add),
          //   onPressed: () {
          //     if (_faceFound) _addLabel();

          //   },
          //   heroTag: null,
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          FloatingActionButton(
            onPressed: _toggleCameraDirection,
            heroTag: null,
            child: _direction == CameraLensDirection.back
                ? const Icon(Icons.camera_front)
                : const Icon(Icons.camera_rear),
          ),
        ]),
      ),
    );
  }

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    int width = image.width;
    int height = image.height;
    // imglib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (_dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  String _recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List(1 * 192).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1).toUpperCase();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";

    _firestore
        .collection('allfaces')
        .doc(_auth.currentUser.uid)
        .collection('faces')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        currDist = 0.0;
        for (int i = 0; i < currEmb.length; i++) {
          currDist +=
              (currEmb[i] - doc.data()['embedding'][i]).abs().toDouble();
        }
        if (currDist < minDist) {
          minDist = currDist;
          predRes = doc.data()['name'];
        }
      }
      print(minDist.toString() + " " + predRes);
      return predRes;
    });
    return predRes;

    // for (String label in data.keys) {
    // currDist = euclideanDistance(data[label], currEmb);
    // if (currDist <= threshold && currDist < minDist) {
    // minDist = currDist;
    // predRes = label;
    //   }
    // }
    // print(minDist.toString() + " " + predRes);
    // return predRes;
  }

  void _resetFile() {
    data = {};
    jsonFile.deleteSync();
  }

  void _viewLabels() {
    setState(() {
      _camera = null;
    });
    String name;
    var alert = new AlertDialog(
      title: new Text("Saved Faces"),
      content: StreamBuilder(
        stream: _firestore
            .collection('allfaces')
            .doc(_auth.currentUser.uid)
            .collection('faces')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: new EdgeInsets.all(2),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              // name = data.keys.elementAt(index);
              name = snapshot.data.docs[index].data()['name'];
              return new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      name,
                      style: new TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  new Divider(),
                ],
              );
            },
          );
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text("OK"),
          onPressed: () {
            _initializeCamera();
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _addLabel() {
    setState(() {
      _camera = null;
    });
    var alert = new AlertDialog(
      title: new Text("Add Face"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _name,
              autofocus: true,
              decoration: new InputDecoration(
                labelText: "Name",
                icon: new Icon(Icons.face),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: Text("Save"),
            onPressed: () {
              _handle(_name.text.toUpperCase());
              _name.clear();
              Navigator.pop(context);
            }),
        new FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            _initializeCamera();
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _handle(String text) {
    _firestore
        .collection('allfaces')
        .doc(_auth.currentUser.uid)
        .collection('faces')
        .doc()
        .set({
      'name': text,
      'embedding': data[text] = e1,
      'uid': _auth.currentUser.uid,
      'login': _auth.currentUser.email,
      'timestamp': DateTime.now(),
    });

    data[text] = e1;
    jsonFile.writeAsStringSync(json.encode(data));
    _initializeCamera();
  }
}
