import 'package:auth_app/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //INSTANCE VARIABLES
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Container(),
              ),
              const FlutterLogo(size: 100),
              SizedBox(
                height: 120,
                child: Container(),
              ),

              //EMAIL LOGICS
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              //PASSWORD LOGICS
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                ),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  obscureText: true,
                ),
              ),

              //HANDLE ONPRESSED
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    loginWithIDAndPassword();
                    emailController.clear();
                    passwordController.clear();
                  },
                  child: const Text('Login'),
                ),
              ),

              //ANOTHER TEXTBUTTON
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //FUNCTION TO HANDLE THE LOGIN FROM THE FIREBASE.
  Future<void> loginWithIDAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No user found fot this email'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Exit',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        // ignore: avoid_print
        print('No user found for this email');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wrong password provided.'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Exit',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );

        //ignore: avoid_print
        print('Wrong password provided.');
      }
    }
  }
}
