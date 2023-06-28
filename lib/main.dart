import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m_n_s_staff_client/interfaces/AddProfilePic.dart';
import 'package:m_n_s_staff_client/interfaces/AmbulanceRequest.dart';
import 'package:m_n_s_staff_client/interfaces/OldAppointments.dart';
import 'package:m_n_s_staff_client/interfaces/doctorsHome.dart';
import 'package:m_n_s_staff_client/interfaces/home.dart';
import 'package:m_n_s_staff_client/interfaces/login.dart';
import 'package:m_n_s_staff_client/interfaces/signup.dart';
import 'firebase_options.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M & S Staff',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        fontFamily: 'Comfortaa',
      ),
      home: const Auth(),
      routes: {
        '/addProfilePic': (context) => const AddProfilePic(),
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUp(),
        '/ambieRequests': (context) => const AmbRequets(),
        '/docHome': (context) => const DocHome(),
      },
    );
  }
}
