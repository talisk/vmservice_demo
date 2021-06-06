import 'dart:isolate';

import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart' as vm;
import 'package:vm_service/vm_service_io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Connect'),
          onPressed: () async {
            ServiceProtocolInfo info = await Service.getInfo();
            String url = info.serverUri.toString();
            Uri uri = Uri.parse(url);
            Uri socketUri = convertToWebSocketUrl(serviceProtocolUrl: uri);
            final isolateId = Service.getIsolateID(Isolate.current);
            final service = await vmServiceConnectUri(socketUri.toString());
            final classList = await service.getClassList(isolateId);
            debugPrint(classList.classes.toString());
          },
        ),
      ),
    );
  }
}
