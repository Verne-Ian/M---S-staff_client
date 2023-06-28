import 'package:flutter/material.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();
  TextEditingController userName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.1, w * 0.03, h * 0.0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: w * 1.2, minWidth: w * 1.2, maxHeight: h * 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shadowColor: Colors.black,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: w * 0.02, right: w * 0.02),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.green.withOpacity(0.4),
                                        fontSize: w * 0.09,
                                        fontFamily: 'DancingScript'),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  defaultField('Enter you full name',
                                      Icons.person, false, userName, ''),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  otherField('Email', Icons.email, false,
                                      emailControl),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  otherField('Enter Password', Icons.lock, true,
                                      passControl),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  loginSignUpButton(context, true, () {
                                    if (_formKey.currentState!.validate()) {
                                      Login.createWithEmail(
                                          userName,
                                          emailControl,
                                          passControl,
                                          userName.text,
                                          emailControl.text,
                                          passControl.text,
                                          context);
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.2,
                          height: w * 0.2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                opacity: 0.9,
                                image: AssetImage(
                                    "assets/images/hospital_min.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          width: w * 0.2,
                          height: w * 0.2,
                          child: Text(
                            'M & S General Clinic',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: h * 0.03,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
        const Text('Have an Account?', style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text(
            'Login Instead.',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
