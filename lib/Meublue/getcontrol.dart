// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:get/get.dart';

// class Readings {
//   Readings(this.year, this.sales);
//   final int year;
//   final double? sales;
// }

// class Control extends GetxController {
//   List<double> readings = [
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0,
//     0.0
//   ].obs;

//   late BluetoothDevice device;
//   late String message = '';
//   late BluetoothConnection connection;

//   bool get isConnected => connection.isConnected;
//   bool isDisconnecting = false;
//   //late RestartableTimer _timer;
//   List<List<int>> chunks = <List<int>>[];
//   int contentLength = 0;
//   addvalues(vai) {
//     readings.add(vai);

//     print('Estas são as leituras>> $readings');
//     update();
//   }

//   // set a device
//   void setDevice(BluetoothDevice d) {
//     device = d;
//     update();
//   }
// }
