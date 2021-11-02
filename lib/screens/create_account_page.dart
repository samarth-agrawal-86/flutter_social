// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social/widgets/header.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
          context: context,
          titleText: 'Set up your profile',
          keepBackButton: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Create a Username',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username must be atleast 3 characters',
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onSaved: (String? value) {
                  usernameController.text = value!;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                //autovalidate: true,
                validator: (String? value) {
                  if (value == null) {
                    return 'username can\'t be empty';
                  } else if (value.trim().length < 3) {
                    return 'Username too short';
                  } else if (value.trim().length > 12) {
                    return 'Username too long';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();

                final snackBar = SnackBar(
                  content: Text('Welcome ${usernameController.text}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Timer(
                  Duration(seconds: 1),
                  () {
                    Navigator.pop(context, usernameController.text);
                  },
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
