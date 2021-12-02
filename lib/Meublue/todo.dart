import 'package:ads1115control/Meublue/getcontrol.dart';
import 'package:flutter/material.dart';

class Functions extends StatefulWidget {
  String nameFunction;
  List<String> functionArg;
  Functions({Key? key, required this.nameFunction, required this.functionArg})
      : super(key: key);

  @override
  State<Functions> createState() =>
      // ignore: no_logic_in_create_state
      _FunctionsState(nomedafuncao: nameFunction, argumento: functionArg);
}

class _FunctionsState extends State<Functions> {
  _FunctionsState({required this.nomedafuncao, required this.argumento});

  late String nomedafuncao;
  List<String> argumento;
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
      children: [
        Card(
          elevation: 2,
          clipBehavior: Clip.hardEdge,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.nameFunction,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              DropdownButton<String>(
                dropdownColor: const Color(0xFFFFFFFF),
                value: widget.functionArg[0],
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFF000000)),
                underline: Container(
                  height: 2,
                  color: Colors.green,
                ),
                onChanged: (String? newValue7) {
                  setState(() {
                    dropdownValue = newValue7!;
                    print(newValue7);
                    setState(() {
                      // print(Control().readings.last.toString());
                    });
                    // controle.sendMessage(
                    //   "sensibilidade" + dropdownValue,
                    // );
                  });
                },
                items: widget.functionArg
                    .map<DropdownMenuItem<String>>((String value7) {
                  return DropdownMenuItem<String>(
                    value: value7,
                    child: Text(value7),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
