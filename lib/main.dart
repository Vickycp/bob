import 'dart:io';
import 'dart:typed_data';
import 'package:explayer/landscape_player_controls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  runApp(MaterialApp(
    home: Per(),
    debugShowCheckedModeBanner: false,
  ));
}

class Per extends StatefulWidget {
  @override
  _PerState createState() => _PerState();
}

class _PerState extends State<Per> {
  bool s1 = false;
  @override
  void initState() {
    super.initState();
    checkSMSPermission();
  }

  checkSMSPermission() async {
    var status = await Permission.storage.status;
    print(status);
    if (!status.isGranted) {
      PermissionStatus permissionStatus = await Permission.storage.request();

      print("permissionStatus ${permissionStatus.isGranted}");

      setState(() {
        s1 = true;
      });
    } else {
      setState(() {
        s1 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (s1 == false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return MyApp();
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<FileSystemEntity> files;

  var status;

  Directory _directory = Directory("/./sdcard");
  @override
  void initState() {
    super.initState();

    files = _directory.listSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explayer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: files.length,
          itemBuilder: (context, index) {
            String name = files[index].path.toString();
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Nextfolder(
                              path: files[index].path,
                              reg: 'file[:][///]+[a-zA-Z0-9]+/',
                            )));
              },
              child: Container(
                height: 30,
                width: double.infinity,
                child: Card(
                    child: Stack(children: [
                  Positioned(
                      child: Icon(
                    Icons.folder,
                    color: Colors.blue,
                  )),
                  Positioned(
                      left: 24,
                      child: Text(
                        name.substring(10),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))
                ])),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Nextfolder extends StatefulWidget {
  final path;
  final reg;
  Nextfolder({this.path, this.reg});

  @override
  _NextfolderState createState() => _NextfolderState();
}

class _NextfolderState extends State<Nextfolder> {
  String path1;
  Directory dir;

  List<FileSystemEntity> files;

  @override
  void initState() {
    super.initState();
    path1 = widget.path;
    dir = Directory(path1 + '/');
    files = dir.listSync();
    // pickfile();
  }

  pickfile() async {
    for (FileSystemEntity file in files) {
      print(file.absolute);
      FileStat f1 = file.statSync();
      print(f1.toString());
      print(f1.type);
      print(f1.size);
    }
  }

  String f;

 getimage(paths) async {
    final uint8list =  await VideoThumbnail.thumbnailFile(
      video: paths.uri,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          20, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 10,
    );
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              String v1 = widget.reg;
              String v2 = '[a-zA-Z0-9.]+/';
              f = v1 + v2;
              print(f);
              String dom = files[index].absolute.uri.toString();
              String v3 = dom.replaceAll(RegExp(f), '');

              return GestureDetector(
                onTap: () {
                  // print(files[index].uri );
                  String v = files[index].uri.toString();

                  if (v.contains(RegExp(r'\.[a-zA-Z0-9]+'))) {
                    if (v.endsWith('.mp4') ||
                        v.endsWith('.m4a') ||
                        v.endsWith('.m4v') ||
                        v.endsWith('.f4v') ||
                        v.endsWith('.f4a') ||
                        v.endsWith('.m4b') ||
                        v.endsWith('.m4r') ||
                        v.endsWith('.f4b') ||
                        v.endsWith('.mov') ||
                        v.endsWith('.3gp') ||
                        v.endsWith('.3gp2') ||
                        v.endsWith('.3g2') ||
                        v.endsWith('.3gpp') ||
                        v.endsWith('.3gpp2') ||
                        v.endsWith('.ogg') ||
                        v.endsWith('.oga') ||
                        v.endsWith('.ogv') ||
                        v.endsWith('.ogx') ||
                        v.endsWith('.wmv') ||
                        v.endsWith('.wma') ||
                        v.endsWith('.asf*') ||
                        v.endsWith('.webm') ||
                        v.endsWith('.flv') ||
                        v.endsWith('AVI*') ||
                        v.endsWith('.HDV*') ||
                        v.endsWith('.MPEG-2 PS') ||
                        v.endsWith('.MPEG-2 TS*')) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Vidoplayers(
                                    path1: files[index],
                                    name: v3,
                                  )));
                    } else {
                      print("not support");
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                                content: Text("$v3 not supported file"),
                              ));
                    }
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Nextfolder(
                                  path: files[index].path,
                                  reg: f,
                                )));
                  }
                },
                child: v3.contains(RegExp(
                        r'(.mp4|.3gp|.m4a|.m4v|.f4v|.f4a|.m4b|.m4r|.f4b|.mov|.3gp2|.3g2|.3gpp|.3gpp2|.ogg|.oga|.ogv|.ogx|.wmv|.wma|.asf*|.webm|.png|.jpg|.gif|.jpeg|.tif|.tiff|.eps|.raw|.cr2|.nef|.orf|.sr2)'))
                    ? Container(
                        height: 30,
                        child: v3.contains(RegExp(
                                r'(.mp4|.3gp|.m4a|.m4v|.f4v|.f4a|.m4b|.m4r|.f4b|.mov|.3gp2|.3g2|.3gpp|.3gpp2|.ogg|.oga|.ogv|.ogx|.wmv|.wma|.asf*|.webm)'))
                            ? Card(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                    Positioned(
                                      child: Container(child:Image.file(getimage(files[index])),
                                    ),
                                    ),
                                    Positioned(
                                        left: 25,
                                        child: Center(child: Text(v3)))
                                  ]))
                            : Card(
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                    Positioned(
                                        left: 0, child: Icon(Icons.image)),
                                    Positioned(
                                        left: 25,
                                        child: Center(child: Text(v3)))
                                  ])),
                      )
                    : Container(
                        height: 30,
                        child: Card(
                            child:
                                Stack(alignment: Alignment.center, children: [
                          Positioned(left: 0, child: Icon(Icons.folder)),
                          Positioned(left: 25, child: Center(child: Text(v3)))
                        ])),
                      ),
              );
            }),
      ),
    );
  }
}

class Vidoplayers extends StatefulWidget {
  final path1;
  final name;
  Vidoplayers({this.path1, this.name});

  @override
  _VidoplayersState createState() => _VidoplayersState();
}

class _VidoplayersState extends State<Vidoplayers> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  FlickManager flickManager;
  FlickVideoProgressBar flickVideoProgressBar;
  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.path1);
    //  _controller = VideoPlayerController.network('https://www.runoob.com/try/demo_source/movie.mp4');
    flickManager = FlickManager(videoPlayerController: _controller);
    flickVideoProgressBar = FlickVideoProgressBar(
      flickProgressBarSettings: FlickProgressBarSettings(
        height: 5,
        handleRadius: 5,
        curveRadius: 50,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white38,
        playedColor: Colors.red,
        handleColor: Colors.red,
      ),
    );
    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name1 =
        widget.name.toString().replaceAll(RegExp(r'\.[a-zA-Z0-9]+'), '');
    return Scaffold(
      appBar: AppBar(
        title: Text(name1),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(1),
                height: 300,
                child: FlickVideoPlayer(
                  flickManager: flickManager,
                  flickVideoWithControls: FlickVideoWithControls(
                    controls: LandscapePlayerControls(),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
