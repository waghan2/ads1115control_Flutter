import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  final BluetoothDevice server;

  const DetailPage({Key? key, required this.server}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late BluetoothConnection connection;
  bool isConnecting = true;

  bool get isConnected => connection.isConnected;
  bool isDisconnecting = false;

  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  late Uint8List _bytes;

  late RestartableTimer _timer;

  @override
  void initState() {
    super.initState();
    _getBTConnection();
    _timer = RestartableTimer(const Duration(seconds: 1), _drawImage);
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
          Get.defaultDialog(
            title: "Desconectado",
            middleText: "Dispositivo desconectado Localmente.",
            backgroundColor: Colors.green,
            titleStyle: TextStyle(color: Colors.white),
            middleTextStyle: TextStyle(color: Colors.white),
          );
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
    if (data != null && data.length > 0) {
      chunks.add(data);
      contentLength += data.length;
      _timer.reset();
    }

    print("Data Length: ${data.length}, chunks: ${chunks.length}");
  }

  void _sendMessage(String text) async {
    text = 'enviando mensagem'.trim();
    if (text.length > 0) {
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting to ${widget.server.name} ...')
              : isConnected
                  ? Text('Connected with ${widget.server.name}')
                  : Text('Disconnected with ${widget.server.name}')),
        ),
        body: SafeArea(
          child: isConnected
              ? Column(
                  children: <Widget>[
                    shotButton(),
                    photoFrame(),
                  ],
                )
              : const Center(
                  child: Text(
                    "Connecting...",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
        ));
  }

  Widget photoFrame() {
    return Expanded(
      child: Container(
        width: double.infinity,
        // child: _bytes != null
        //     ? PhotoView(
        //         enableRotation: true,
        //         initialScale: PhotoViewComputedScale.covered,
        //         maxScale: PhotoViewComputedScale.covered * 2.0,
        //         minScale: PhotoViewComputedScale.contained * 0.8,
        //         imageProvider: Image.memory(_bytes, fit: BoxFit.fitWidth).image,
        //       )
        //     : Container(),
      ),
    );
  }

  Widget shotButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.red)),
          onPressed: () {
            _sendMessage('helow word');
          },
          color: Colors.red,
          textColor: Colors.white,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Enviar Mensagem',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectFrameSize() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      // child: DropDownFormField(
      //   titleText: 'FRAMESIZE',
      //   hintText: 'Please choose one',
      //   value: _selectedFrameSize,
      //   onSaved: (value) {
      //     _selectedFrameSize = value;
      //     setState(() {});
      //   },
      //   onChanged: (value) {
      //     _selectedFrameSize = value;
      //     setState(() {});
      //   },
      //   dataSource: [
      //     {"value": "4", "display": "1600x1200"},
      //     {"value": "3", "display": "1280x1024"},
      //     {"value": "2", "display": "1024x768"},
      //     {"value": "1", "display": "800x600"},
      //     {"value": "0", "display": "640x480"},
      //   ],
      //   textField: 'display',
      //   valueField: 'value',
      // ),
    );
  }
}
