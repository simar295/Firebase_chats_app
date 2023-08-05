import 'package:flutter/material.dart';

class splashcreen extends StatelessWidget {
  const splashcreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: Center(child: Text("LOADING....")),
    );
  }
}
