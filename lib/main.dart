import 'package:ads1115control/Meublue/datamap.dart';
import 'package:ads1115control/Meublue/myapp.dart';
import 'package:ads1115control/Meublue/todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/home',
    home: Home(),
    getPages: [
      GetPage(name: '/home', page: () => Home()),
      GetPage(name: '/Conectar', page: () => MyApp()),
    ],
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF410000),
          title: const Text('Ads1115 Control by Esp32S'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Carousel(
                    autoplay: false,
                    boxFit: BoxFit.cover,
                    images: const [
                      ExactAssetImage("assets/ADS1115_module.jpg"),
                      ExactAssetImage("assets/foto.jpg"),
                      ExactAssetImage("assets/foto2.jpg")
                    ],
                  )),
              Center(
                  child: IconButton(
                      onPressed: () {
                        Get.toNamed('/Conectar');
                      },
                      icon: const Icon(Icons.search))),
              Center(
                  child: IconButton(
                      onPressed: () {
                        Get.toNamed('/Conectado');
                      },
                      icon: const Icon(Icons.home))),
              Center(
                  child: IconButton(
                      onPressed: () {
                        Get.toNamed('/todo');
                      },
                      icon: const Icon(Icons.list))),
              ...todos.map(
                (todos) => Funcoes(
                  nomedafuncao: todos.Function,
                  argumento: todos.argfunction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
