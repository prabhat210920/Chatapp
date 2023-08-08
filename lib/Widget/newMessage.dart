import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class newMessage extends StatefulWidget{
  const newMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _newMessage();
  }
}
class _newMessage extends State<newMessage> {
  var _messageControler = TextEditingController();
  @override
  void _dispose(){
    _messageControler.dispose();
    super.dispose();
  }
  void _submit()  async {
    final message = _messageControler.text;
    if(message.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    _messageControler.clear();

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    print(userData.data()!['userName']);
    print(userData.data()!['imageUrl']);
    FirebaseFirestore.instance.collection('chat').add({
      'chat': message,
      'created at' : Timestamp.now(),
      'UserId' : user.uid,
      'UserName' : userData.data()!['userName'],
      'UserImage' : userData.data()!['imageUrl']
    });



  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: const EdgeInsets.only(
        left: 15, right: 1, bottom: 15),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _messageControler,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'Enter a message'),
          )),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
              onPressed: _submit,
              icon: Icon(Icons.send),),

        ],
      ),
    );

  }
}