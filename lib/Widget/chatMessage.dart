import 'package:chat_app/Widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatMessage extends StatelessWidget {
  const chatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final _authenticatedUser = FirebaseAuth.instance.currentUser!;
    // TODO: implement build
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        builder: (ctx, snp) {
          if (snp.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snp.hasData || snp.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data found'),
            );
          }
          if (snp.hasError) {
            return const Center(
              child: Text('something went wrong'),
            );
          }
          final loadedData = snp.data!.docs;
          // print(laodedData);
          return ListView.builder(
              padding: const EdgeInsets.only(
                  top: 5, left: 10, right: 10, bottom: 45),
              reverse: true,
              itemCount: loadedData.length,
              itemBuilder: (ctx, ind) {
                final chat_message = loadedData[ind].data();
                final nextMessage = ind + 1 < loadedData.length
                    ? loadedData[ind + 1].data()
                    : null;
                final currentMessageUserId = chat_message['UserId'];
                final nextMessageUserId =
                    nextMessage != null ? nextMessage['UserId'] : null;
                final nextMessageIsSame =
                    currentMessageUserId == nextMessageUserId;
                if (nextMessageIsSame) {
                  return MessageBubble.next(
                      message: chat_message['chat'],
                      isMe: _authenticatedUser.uid == currentMessageUserId);
                }else{
                  return MessageBubble.first(userImage: chat_message['UserImage'],
                      username: chat_message['UserName'],
                      message: chat_message['chat'],
                      isMe: _authenticatedUser.uid == currentMessageUserId);
                }
              });
        });
  }
}
