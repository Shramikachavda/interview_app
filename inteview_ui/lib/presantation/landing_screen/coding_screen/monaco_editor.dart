import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';

class MonacoEditor extends StatefulWidget {
  final String initialCode;
  final String language;
  final Function(String) onCodeChanged;
  final bool readOnly;
  final String? theme;

  const MonacoEditor({
    Key? key,
    required this.initialCode,
    required this.language,
    required this.onCodeChanged,
    this.readOnly = false,
    this.theme = 'vs-dark',
  }) : super(key: key);

  @override
  State<MonacoEditor> createState() => _MonacoEditorState();
}

class _MonacoEditorState extends State<MonacoEditor> {
  late InAppWebViewController _webViewController;
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    _currentCode = widget.initialCode;
  }

  String getEditorHtml() {
    return """
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    html, body, #container {
      height: 100%;
      margin: 0;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <div id="container"></div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs/loader.min.js"></script>
  <script>
    var editor;
    require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs' }});
    require(['vs/editor/editor.main'], function () {
      editor = monaco.editor.create(document.getElementById('container'), {
        value: atob('${base64.encode(utf8.encode(widget.initialCode))}'),
        language: '${widget.language}',
        theme: '${widget.theme}',
        automaticLayout: true,
        readOnly: ${widget.readOnly},
        minimap: { enabled: false },
        fontSize: 14,
        lineNumbers: 'on',
        roundedSelection: false,
        scrollBeyondLastLine: false,
        automaticLayout: true,
        wordWrap: 'on'
      });

      editor.onDidChangeModelContent(function() {
        var code = editor.getValue();
        window.flutter_inappwebview.callHandler('codeChanged', code);
      });

      window.getCode = function() {
        return editor.getValue();
      };

      window.setCode = function(code) {
        editor.setValue(code);
      };

      window.setLanguage = function(lang) {
        monaco.editor.setModelLanguage(editor.getModel(), lang);
      };
    });
  </script>
</body>
</html>
""";
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: getEditorHtml(),
        mimeType: 'text/html',
        encoding: 'utf-8',
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
        controller.addJavaScriptHandler(
          handlerName: 'codeChanged',
          callback: (args) {
            if (args.isNotEmpty) {
              final code = args[0] as String;
              _currentCode = code;
              widget.onCodeChanged(code);
            }
          },
        );
      },
    );
  }

  void setCode(String code) {
    _webViewController.evaluateJavascript(source: "setCode('${code.replaceAll("'", "\\'")}');");
  }

  void setLanguage(String language) {
    _webViewController.evaluateJavascript(source: "setLanguage('$language');");
  }

  String getCode() {
    return _currentCode;
  }
} 