import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chats_app/widgets/chatmessages.dart';
import 'package:firebase_chats_app/widgets/newmessage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({super.key});

  @override
  State<chatscreen> createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  void snotifications() async {
    final fcm = FirebaseMessaging.instance;
    /* final fcmsettings = */
    await fcm.requestPermission();
    fcm.subscribeToTopic('chats');
    ////address of device to target notifications
    final gettoken = await fcm.getToken();
    print("token  is");
    print(gettoken);
  }

  @override
  void initState() {
    super.initState();
    snotifications();
  }

  /////////////////////////////////////////////
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
        body: Column(
          children: [
            ////pushing both screens to full height
            ///send widget came down
            Expanded(
              child: chatmessages(),
            ),
            newmessage(),
          ],
        ));
  }
}
