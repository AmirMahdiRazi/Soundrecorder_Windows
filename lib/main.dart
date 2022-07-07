import 'package:flutter/material.dart';
import 'temp.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recorder',
      theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Colors.teal,
      )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    testWindowFunctions();
    super.initState();
  }

  Future testWindowFunctions() async {
    Size size = await DesktopWindow.getWindowSize();
    print(size);
    await DesktopWindow.setMinWindowSize(Size(1200, 800));
    await DesktopWindow.setFullScreen(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Recorder')),
      ),
      body: Window_recorder(),
    );
  }
}
