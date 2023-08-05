import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatscreen extends StatelessWidget {
  const chatscreen({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(child: Text("logged in")),
    );
  }
}
