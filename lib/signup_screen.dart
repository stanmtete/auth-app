import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //INSTANCE VARIABLE DECLARATION
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Sing Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              nameTextFormField('Name', nameController),
              emailTextFormField('Email', emailController),
              passwordTextFormField('Password', passwordController),
              elevatedButton(
                signupWithEmailPassword,
                nameController,
                emailController,
                passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //NAME FUNCTION HANDLERS
  Widget nameTextFormField(String fieldName, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   fieldName,
        //   style: const TextStyle(
        //     fontSize: 20,
        //   ),
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 21),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: const TextStyle(color: Colors.grey),
              // contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$fieldName required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  //EMAIL FUNCTION HANDLER
  Widget emailTextFormField(
      String fieldName, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   fieldName,
        //   style: const TextStyle(fontSize: 20),
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 25),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: const TextStyle(color: Colors.grey),
              // contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$fieldName required';
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  //PASSWORD FUNCTION HANDLER
  Widget passwordTextFormField(
      String fieldName, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   fieldName,
        //   style: const TextStyle(fontSize: 20),
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 25),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: fieldName,
              hintStyle: const TextStyle(color: Colors.grey),
              // contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$fieldName required';
              } else if (value.length < 8) {
                return '$fieldName too short should be atleat 8 character';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  //ELEVATED BUTTON HANDLER
  Widget elevatedButton(
    Function signupController,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController paswdController,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            signupController().whenComplete(() {
              nameController.clear();
              emailController.clear();
              paswdController.clear();
            });
          }
        },
        // onPressed: addUser,
        child: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  //FUNCTION TO HANDLE THE SIGNUP LOGICS FROM THE FIREBASE
  Future<void> signupWithEmailPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(emailController.text)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }).then((value) {
        //ignore: avoid_print
        print('User Added');
      }).catchError((error) {
        //ignore: avoid_print
        print('Failed to add usrer: $error');
      });

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: avoid_print
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // ignore: avoid_print
        print('The account already exists for this email');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('The account already exists for that email'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Exit',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //ADD DATA TO FIREBASE FIRESTORE
  Future<void> addUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .add({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        })
        .then((value) => print('Data added!'))
        .catchError((error) => print('Failed to add user'));
  }
}
