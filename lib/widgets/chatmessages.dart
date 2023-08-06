import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chats_app/widgets/messagebubble.dart';
import 'package:flutter/material.dart';

class chatmessages extends StatelessWidget {
  const chatmessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticateduserid = FirebaseAuth.instance.currentUser!;

    ////used when fetch data from internet and then build some widget
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdat', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("no messages found, Start chatting"),
          );
        }
        if (snapshot.hasError) {
          Center(
            child: Text("something went wrong"),
          );
        }

        final loadedmessages = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          ////list is reversed from top to bottom
          reverse: true,
          itemCount: loadedmessages.length,
          itemBuilder: (context, index) {
            final chatmess = loadedmessages[index].data();
            final nextchatmess = index + 1 < loadedmessages.length
                ? loadedmessages[index + 1].data()
                : null;

            final currentchatuserid = chatmess['userid'];
            final nextchatuserid =
                nextchatmess != null ? nextchatmess['userid'] : null;
            final nextuserissame = nextchatuserid == currentchatuserid;

            if (nextuserissame) {
              return MessageBubble.next(
                  message: chatmess['text'],
                  isMe: authenticateduserid.uid == currentchatuserid);
            } else {
              return MessageBubble.first(
                  userImage: chatmess['userimage'],
                  username: chatmess['username'],
                  message: chatmess['text'],
                  isMe: authenticateduserid.uid == currentchatuserid);
            }
          },
        );
      },
    );
  }
}
