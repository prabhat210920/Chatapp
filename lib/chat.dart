import 'package:chat_app/Widget/chatMessage.dart';
import 'package:chat_app/Widget/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget{
  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  // const chatScreen({super.key});
  void pushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print("token ${token}");
  }

  @override
  void initState() {
    super.initState();
    pushNotification();
    print("Push Completed");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with the world'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          },
              icon: Icon(Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary, size: 35,)
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: chatMessage()),
          newMessage(),

        ],
      ),
    );
  }
}