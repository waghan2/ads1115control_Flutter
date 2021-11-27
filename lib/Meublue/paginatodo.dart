import 'package:flutter/material.dart';

class PaginaTodo extends StatelessWidget {
  PaginaTodo({Key? key, required this.funcname}) : super(key: key);
  String funcname;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(funcname),
      ],
    );
  }
}
