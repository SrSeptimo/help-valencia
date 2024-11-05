import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart'; // Importar el paquete

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https://github.com/SrSeptimo/help-valencia/releases/download/release1/video.mp4",
    )..initialize().then((_) {
        setState(() {
          Future.delayed(Duration(milliseconds: 5000), () {
            //_controller.play();
          });
        });
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _controller.pause();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text("Video Player Test - Ayuda Valencia"))),
      body: SingleChildScrollView(
        child: Center(
          child: _controller.value.isInitialized
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Contenedor para el video con un tamaño específico
                      Container(
                        width: 980, // Ancho deseado
                        height: 420, // Alto deseado
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      Container(
                        width: 780,
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'https://play.google.com/store/apps/details?id=com.yourapp'));
                            },
                            child: Text("Google Play"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  'https://apps.apple.com/app/idYOUR_APP_ID'));
                            },
                            child: Text("App Store"),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
