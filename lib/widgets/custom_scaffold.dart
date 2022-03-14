import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  
  final String appBarTitle;
  final Widget body;
  final Widget? leading;

  const CustomScaffold({
    Key? key, 
    required this.appBarTitle,
    required this.body,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: leading,
        automaticallyImplyLeading: false,
      ),
      body: body
    );
  }
}