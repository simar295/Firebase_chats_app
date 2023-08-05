import 'package:flutter/material.dart';

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

  void submit() {
    final isvalid = formkey.currentState!.validate();
    if (isvalid) {
      formkey.currentState!.save();
      print(enteredemail);
      print(enteredpassword);
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
                          ElevatedButton(
                            onPressed: submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text(isloggined ? "Login" : "sign up"),
                          ),
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
