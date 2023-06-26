import 'package:flutter/material.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.0, w * 0.05, h * 0.0),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: w * 0.5, minWidth: w * 0.5, minHeight: h * 0.7),
            child: Column(
              children: [
                Container(
                  width: w * 0.55,
                  height: h * 0.2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.9,
                        image: AssetImage("assets/images/smallUnesco.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Card(
                  shadowColor: Colors.black,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blue.withOpacity(0.4),
                                fontSize: w * 0.09),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          otherField(
                              'Email', Icons.person, false, emailControl),
                          const SizedBox(
                            height: 12.0,
                          ),
                          otherField(
                              'Enter Password', Icons.lock, true, passControl),
                          const SizedBox(
                            height: 8.0,
                          ),
                          loginSignUpButton(context, true, () {
                            if (_formKey.currentState!.validate()) {
                              Login.emailLogin(emailControl, passControl,
                                  emailControl.text, passControl.text, context);
                            }
                          }),
                          signUpOption(),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No Account?', style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/sign');
          },
          child: const Text(
            'Contact Admin.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
