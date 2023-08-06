import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class newmessage extends StatefulWidget {
  const newmessage({super.key});

  @override
  State<newmessage> createState() => _newmessageState();
}

class _newmessageState extends State<newmessage> {
  final messagecontroller = TextEditingController();

  @override
  void dispose() {
    messagecontroller.dispose();
    super.dispose();
  }

  ///////collecting data from sendmessage widget
  void submitmessage() async {
    final enteredmessage = messagecontroller.text;
    if (enteredmessage.trim().isEmpty) {
      return;
    }
    ////remove opened keyboard
    FocusScope.of(context).unfocus();
    messagecontroller.clear();

    ///sending to firebase like did in auth.dart
    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredmessage,
      'createdat': Timestamp.now(),
      'userid': user.uid,
      'username': userdata.data()!['username'],
      'userimage': userdata.data()!['image_url'],
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: messagecontroller,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: "send message"),
          ),
        ),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: submitmessage,
          icon: Icon(Icons.send),
        ),
      ]),
    );
  }
}
