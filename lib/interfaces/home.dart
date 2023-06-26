import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_n_s_staff_client/addons/drawer.dart';
import 'package:m_n_s_staff_client/interfaces/doctorsHome.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String? name = user!.displayName;
  late String? userId = user!.uid;
  late String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainSideBar(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Staff_Users')
            .where('UserId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.all(40.0),
                    child: Text('No Messages yet.'),
                  ),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Card(
                elevation: 10,
                margin: EdgeInsets.all(40.0),
                child: Text('Loading'),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }

          var redirectData =
              snapshot.data!.docs[0].data() as Map<String, dynamic>;
          var role = redirectData['Role'];

          switch (role) {
            case 'Doctor':
              return const DocHome();
            case 'Staff':
              return const MyHomePage(title: 'Staff');
            default:
              // Handle unknown role or other cases
              return const SizedBox();
          }
        },
      ),
    );
  }
}
