import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web3View extends StatefulWidget {

  final initialUrl;
  final address;
  final rpcurl;
  final chainId;
  final Function(String result) jsResult;

  Web3View({@required this.initialUrl, @required this.address, @required this.rpcurl, @required this.chainId,@required this.jsResult});

  @override
  _Web3ViewState createState() => _Web3ViewState();
}

class _Web3ViewState extends State<Web3View> {

  WebViewController _myController;

  ///
  /// 交易
  ///
  JavascriptChannel signTransaction(BuildContext context) => JavascriptChannel(
      name: 'signTransaction', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signTransaction = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// signMessage
  ///
  JavascriptChannel signMessage(BuildContext context) => JavascriptChannel(
      name: 'signMessage', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signMessage = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// signPersonalMessage
  ///
  JavascriptChannel signPersonalMessage(BuildContext context) => JavascriptChannel(
      name: 'signPersonalMessage', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signPersonalMessage = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// signTypedMessage
  ///
  JavascriptChannel signTypedMessage(BuildContext context) => JavascriptChannel(
      name: 'signTypedMessage', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signTypedMessage = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// eth_signTypedData_v3
  ///
  JavascriptChannel eth_signTypedData_v3(BuildContext context) => JavascriptChannel(
      name: 'eth_signTypedData_v3', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:eth_signTypedData_v3 = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// requestAccounts
  ///
  JavascriptChannel requestAccounts(BuildContext context) => JavascriptChannel(
      name: 'requestAccounts', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:requestAccounts = " + message.message);
        widget.jsResult(message.message);
      });

  ///
  /// eth_requestAccounts
  ///
  JavascriptChannel eth_requestAccounts(BuildContext context) => JavascriptChannel(
      name: 'eth_requestAccounts', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
//        Wallet wallet = Provider.of<Wallet>(context);
//        String address = wallet.currentWalletObject["address"];
        print("js:eth_requestAccounts = " + message.message);
        var messageList = message.message.split("#");
        String paramString = "window.ethereum.sendResponse(${messageList[0]}, ['${widget.address}'])";
        await _myController.evaluateJavascript(paramString).then((value){
          print(value);
        });
        widget.jsResult(message.message);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      body: Consumer2<Wallet,Network>(
//        builder: (context,wallet,network,widget){
      body: Container(
//            child: getPlatformView(wallet,network),
        child: WebView(
          initialUrl: widget.initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: "random",
          onWebViewCreated: (controller)async{
            _myController = controller;
          },
          javascriptChannels: <JavascriptChannel>{
            signTransaction(context),
            signMessage(context),
            signPersonalMessage(context),
            signTypedMessage(context),
            eth_signTypedData_v3(context),
            requestAccounts(context),
            eth_requestAccounts(context),
          },
          onPageFinished: (str)async{
//                String js = 'window.rpcurl="${Global.getBaseUrl()}";window.wsrpc="${Global.getWSBaseUrl()}"; window.defaultAccount = "${wallet.currentWalletObject["address"]}";window.setConfig();';
//                String rpcurl = await Global.getBaseUrl();
//                String address = wallet.currentWalletObject["address"];
//                String chainId = "${network.chainId}";
            String js = await rootBundle.loadString("assets/trust.js");
            String js1 = await rootBundle.loadString("assets/init.js");
            js1 = js1.replaceFirst("\$rpcurl", widget.rpcurl);
            js1 = js1.replaceFirst("\$address", widget.address);
            js1 = js1.replaceFirst("\$chainId", widget.chainId);
            // 此处ios会遇到一个问题，解决方案参考 https://github.com/flutter/flutter/issues/66318
            await _myController.evaluateJavascript(js).then((value){
              print(value);
            });
            await _myController.evaluateJavascript(js1).then((value){
              print(value);
            });
//                await _myController.evaluateJavascript("window.setConfig()").then((value){
//                  print(value);
//                });
          },
        ),
      ),
//        },
//      ),
    );
  }

}

