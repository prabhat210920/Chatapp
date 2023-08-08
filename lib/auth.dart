import 'package:chat_app/Widget/User_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;
var _islogin = true;

class authScreen extends StatefulWidget{
  const authScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _authScreen();
  }
}
class _authScreen extends State<authScreen>{
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _authenticating = false;
  var _enteredUserName = '';
  File? _selectedImage;
  void submit() async {
    final _isValid = _formKey.currentState!.validate();
    if (!_isValid || !_islogin && _selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);
    print(_firebase);

    try {
      setState(() {
        _authenticating = true;
      });
      if (_islogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        final storageRef = FirebaseStorage.instance.ref().child('UserImage').child('${userCredential.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);
        await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.uid).set({
          'userName' : _enteredUserName,
          'imageUrl' : imageUrl,
          'email' : _enteredEmail
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed'),),
      );
    }
    setState(() {
      _authenticating = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                bottom: 30,
                left: 20,
                right: 20
              ),
              width: 200,
              child: Image.asset('assets/images/chat.png'),
            ),
            Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(!_islogin) userImagePicker(onPickImage: (pickedimage) {
                          _selectedImage = pickedimage;
                        },),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email'
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value){
                            if(value == null || value.trim().isEmpty || !value.contains('@')){
                              return 'Please Enter a valid email id';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _enteredEmail = value!;
                          },
                        ),
                        if(!_islogin)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'UserName',
                          ),
                          validator: (value){
                            if(value == null ||value.isEmpty || value.length<6 || value.contains(" ")){
                              return 'Plese Enter valid user name';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _enteredUserName = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password'
                          ),
                          obscureText: true,
                          validator: (value){
                            if(value == null || value.trim().length <6){
                              return 'password must be atleast 6 character long';
                            }
                            return null;
                          },
                          onSaved: (value){
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if(_authenticating)
                          const CircularProgressIndicator(),
                        if(!_authenticating)
                          ElevatedButton(
                           // Setst
                            onPressed: submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Text(_islogin ? 'login' : 'signup'),
                        ),

                        if(!_authenticating)
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },

                            child: Text(
                            _islogin ? 'create an account' : 'I already have an account login'
                            ))
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}