import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Area for displaying text
          Text(
            'Welcome to our App!',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20), // Adds spacing between elements
          // Button
          Center(
            // Center widget added to center the button
            child: ElevatedButton(
              onPressed: () {
                _openCamera(context);
                // Add functionality to open camera here
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.black), // Set button background color to black
                foregroundColor: MaterialStateProperty.all(
                    Colors.white), // Set text color to white
              ),
              child: Text('Open Camera'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Set the background color to black
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Adjusted alignment
          children: [
            // Phone number (left-aligned)
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0), // Add padding for left alignment
              child: Text(
                'Phone: 123-456-7890',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            // Visit Website button (right-aligned)
            Padding(
              padding: const EdgeInsets.only(
                  right: 8.0), // Add padding for right alignment
              child: TextButton(
                onPressed: () {
                  _launchURL('https://www.youtube.com/watch?v=vFcj37kw_28');
                  // Add functionality to open website here
                },
                child: Text(
                  'Visit Website',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch URL
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to open camera
  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: firstCamera),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
