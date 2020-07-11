import 'package:drop_chip/menu_layout.dart';
import 'package:drop_chip/siginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MediaQuery(
    data: new MediaQueryData(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: signinPage());
  }
}

