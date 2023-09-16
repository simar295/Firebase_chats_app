import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chats_app/widgets/imagewidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firebase = FirebaseAuth.instance;

class authscreen extends StatefulWidget {
  const authscreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return authsreenstate();
  }
}

class authsreenstate extends State<authscreen> {
  
  var isloggined = true;
  final formkey = GlobalKey<
      FormState>(); //getting access to the form just like controller.text

  var enteredemail = '';
  var enteredpassword = '';
  File? enteredimage;
  var isauthenticating = false;
  var enteredusername = '';

  void submit() async {
    /////form validating checking
    final isvalid = formkey.currentState!.validate();

    if (!isvalid || !isloggined && enteredimage == null) {
      //show error message
      return;
    }

    formkey.currentState!.save();
////////// loggin and sign in checking
    try {
      setState(() {
        isauthenticating = true;
      });
      if (isloggined) {
        final usercredentials = await firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
      } else {
        final usercredentials = await firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
        //////storing images
        final usercredentialsimage = FirebaseStorage.instance
            .ref()
            .child("user images")
            .child("${usercredentials.user!.uid}.jpg");

        await usercredentialsimage.putFile(enteredimage!);
        final imageurl = await usercredentialsimage.getDownloadURL();
        print(imageurl);
        ////// creating and storing folder containing user data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredentials.user!.uid)
            .set({
          'username': enteredusername,
          'email': enteredemail,
          'image_url': imageurl,
        });
        ;
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'error message ?? authentication failed') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email already exists"),
        ),
      );
      setState(() {
        isauthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 260,
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                child: Image.asset(
                  'assets/image1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isloggined)
                            imagewidget(
                              getpickedimage: (pickedimage) {
                                enteredimage = pickedimage;
                              },
                            ),
                          if (!isloggined)
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Username"),
                              enableSuggestions: true,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 3) {
                                  return "please enter a username of more than 3 words";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                enteredusername = value!;
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text(isloggined
                                  ? "email address"
                                  : "Enter a email address"),
                            ),
                            validator: (value /* entered value*/) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains("@")) {
                                return "please enter a valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredemail = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text(isloggined
                                  ? "password"
                                  : "Create a password"),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "password must be atleast 6 characters long";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredpassword = value!;
                            },
                            obscureText: true, //hide characters
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (isauthenticating)
                            CircularProgressIndicator(), //adding single if checks for widgets rendering
                          if (!isauthenticating)
                            ElevatedButton(
                              onPressed: submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(isloggined ? "Login" : "sign up"),
                            ),
                          if (!isauthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isloggined = !isloggined;
                                });
                              },
                              child: Text(isloggined
                                  ? "create an account"
                                  : "Already have an account !"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
