import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web3_provider/flutter_web3_provider.dart';
import 'package:flutter_web3_provider/web3view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterWeb3Provider.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('web3provider'),
        ),
        body: Container(
          child: Web3View(
              initialUrl: "https://pandora.vpntube.app/build/index.html#/swap",
              address: "0xb44b516931375c9f7bfce23e339b70a811da9885",
              rpcurl: "https://ropsten.infura.io/v3/9ff09f1a3c284d28830665290dab81c5",
              chainId: "3",
              jsResult: (result){
                print("web3action:$result"
              );
          }),
        ),
      ),
    );
  }
}
