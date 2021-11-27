import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:async/async.dart';

class MeuBlue extends StatefulWidget {
  final BluetoothDevice server;
  const MeuBlue({required this.server});

  @override
  State<MeuBlue> createState() => _MeuBlueState();
}

class _MeuBlueState extends State<MeuBlue> {
  late BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  late RestartableTimer _timer;
  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  late Uint8List _bytes;

  @override
  void initState() {
    super.initState();

    _getBTConnection();
    _timer = RestartableTimer(Duration(seconds: 1), _drawImage);
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection;
    }
    _timer.cancel();
    super.dispose();
  }

  _getBTConnection() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      setState(() {});
      connection.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally');
        } else {
          print('Disconnecting remotely');
        }
        if (mounted) {
          setState(() {});
        }
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }

  _drawImage() {
    if (chunks.isEmpty || contentLength == 0) return;

    _bytes = Uint8List(contentLength);
    int offset = 0;
    for (final List<int> chunk in chunks) {
      _bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    setState(() {});

    // SVProgressHUD.showInfo("Downloaded...");
    // SVProgressHUD.dismissWithDelay(1000);

    contentLength = 0;
    chunks.clear();
  }

  void _onDataReceived(Uint8List data) {
    if (data.isNotEmpty) {
      chunks.add(data);
      contentLength += data.length;
      _timer.reset();
    }

    print("Data Length: ${data.length}, chunks: ${chunks.length}");
  }

  void _sendMessage(String text) async {
    text = 'enviando mensagem'.trim();
    if (text.isNotEmpty) {
      try {
        connection.output.add(ascii.encode(text));
        // SVProgressHUD.show("Requesting...");
        await connection.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('meu blue'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _sendMessage('Enviando daqui');
                },
                child: const Text('Envair'))
          ],
        ),
      ),
    );
  }
}
