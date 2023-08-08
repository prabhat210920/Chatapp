import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loadingScreen extends StatelessWidget{
  const loadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with the world'),
      ),
      body: Center(child: Text('loading'),),
    );
  }
}