import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final int year;
  final double? sales;
}

class Controle extends GetxController {
  List<double> leituras = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ].obs;

  late BluetoothDevice device;
  late String message = '';
  late BluetoothConnection connection;
  bool isConnecting = true;
  String voltage = '0.0';
  String sensibilidade = '0.0';
  String intermax = '0.0';
  String intermin = '0.0';
  String pulso = '0.0';
  String temp = '0.0';
  String modop = '0.0';
  String sfile = '0.0';
  String lemrst = '0.0';
  String fim = '0.0';

  String msg = '0.0';

  String msgj = '1.0 mJ';

  bool get isConnected => connection.isConnected;
  bool isDisconnecting = false;
  //late RestartableTimer _timer;
  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  addvalues(vai) {
    leituras.add(vai);

    print('Estas são as leituras>> $leituras');
    update();
  }

  // set a device
  void setDevice(BluetoothDevice d) {
    device = d;
    update();
  }
}

// onDataReceived(Uint8List data) {
//     if (data.isNotEmpty) {
//       String dataStr = ascii.decode(data);
//       message += dataStr;
//       // print('Valor recebido: $dataStr');
//       //chunks.add(data);

// // voltage
// // sensibilidade
// // intermax
// // intermin
// // pulso
// // temp
// // modop
// // sfile
// // lemrst
// // fim
//       if (dataStr.contains('voltage')) {
//         voltage = message.replaceAll('voltage', '');
//         voltage = voltage.replaceAll('\n', '');
//         print('voltage: $voltage');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('sensibilidade')) {
//         sensibilidade = message.replaceAll('sensibilidade', '');
//         sensibilidade = sensibilidade.replaceAll('\n', '');
//         print('sensibilidade: $sensibilidade');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('intermax')) {
//         intermax = message.replaceAll('intermax', '');
//         intermax = intermax.replaceAll('\n', '');
//         print('intermax: $intermax');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('intermin')) {
//         intermin = message.replaceAll('intermin', '');
//         intermin = intermin.replaceAll('\n', '');
//         print('intermin: $intermin');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('pulso')) {
//         pulso = message.replaceAll('pulso', '');
//         pulso = pulso.replaceAll('\n', '');
//         print('pulso: $pulso');
//         message = '';
//         update();
//       }

//       if (dataStr.contains('modop')) {
//         modop = message.replaceAll('modop', '');
//         modop = modop.replaceAll('\n', '');
//         print('modop: $modop');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('sfile')) {
//         sfile = message.replaceAll('sfile', '');
//         sfile = sfile.replaceAll('\n', '');
//         print('sfile: $sfile');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('lemrst')) {
//         lemrst = message.replaceAll('lemrst', '');
//         lemrst = lemrst.replaceAll('\n', '');
//         print('lemrst: $lemrst');
//         message = '';
//         update();
//       }
//       if (dataStr.contains('fim')) {
//         fim = message.replaceAll('fim', '');
//         fim = fim.replaceAll('\n', '');
//         print('fim: $fim');
//         message = '';
//         update();
//       }

//       // if (dataStr.contains('pulso')) {
//       //   pulso = message.replaceAll('pulso', '');
//       //   pulso = pulso.replaceAll('\n', '');
//       //   print("pulso armazenado$pulso");
//       //   message = '';
//       // }

//       if (dataStr.contains('temp')) {
//         temp = message.replaceAll('temp', '');
//         temp = temp.replaceAll('\n', '');
//         print(temp);
//         double doublemsg = double.parse(temp).toDouble();
//         // print('Meter Value $_meterValue');
//         // print('Temperature value $_temperatureValue');
//         //var intmsg = int.parse(msg);
//         addvalues(doublemsg);
//         //print(leituras);
//         //print(leituras.obs);
//         //print('Valores de leitura>>>>>>>>>>>>>>>>>$leitura');

//         // print(ascii.encode(msg),);
//         // print(message);
//         // print('data $data');  print('dataStr $dataStr'); // here you get complete string
//         update();
//         message = ''; //clear buffer to accept new string
//       }
//       ;

//       //print('Data incoming: ${ascii.decode(data)}');
//       contentLength += data.length;
//       update();
//       //_timer.reset();
//     }

//     // print(
//     //     "Tamanho do dado recebido: ${data.length}, Numero de leituras: ${chunks.length}");
//     update();
//   }