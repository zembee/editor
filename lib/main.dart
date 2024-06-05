import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JavaScriptEditor(),
    );
  }
}

class JavaScriptEditor extends StatefulWidget {
  const JavaScriptEditor({super.key});

  @override
  _JavaScriptEditorState createState() => _JavaScriptEditorState();
}

class _JavaScriptEditorState extends State<JavaScriptEditor> {
  late WebViewController _controller;
  String _editorData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor.js in Flutter'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _controller.runJavascript('getEditorData()');
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
        javascriptMode: JavascriptMode.unrestricted,

        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'flutter_inappwebview',
            onMessageReceived: (JavascriptMessage message) {
              print("message ${ message.message }");
              setState(() {
                _editorData = message.message;
              });
            },
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        onPressed: () {
  
          print("_editorData ${ _editorData }");
        },
      ),
    );
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/editor.html');
    _controller.loadUrl(Uri.dataFromString(
      fileText,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }
}


