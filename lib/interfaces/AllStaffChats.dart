import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chatpage.dart';

class AllStaff extends StatefulWidget {
  const AllStaff({super.key});

  @override
  State<AllStaff> createState() => _AllStaffState();
}

class _AllStaffState extends State<AllStaff> {
  late User? user = FirebaseAuth.instance.currentUser;
  late final String? senderName = user!.displayName;
  final CollectionReference firestore =
      FirebaseFirestore.instance.collection('Staff_Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream:
              firestore.where('UserId', isNotEqualTo: user!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Users found'));
            } else if (snapshot.hasData) {
              final List<DocumentSnapshot> users = snapshot.data!.docs;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  // Access the user data for each document
                  final userData = users[index].data() as Map<String, dynamic>;

                  // Extract the desired fields from userData
                  final String userId = userData['UserId'] ?? '';
                  final String receiverName = userData['Name'] ?? '';
                  final String email = userData['Email'] ?? '';
                  final String? userPic = userData['ProfilePic'];

                  ImageProvider profilePic;
                  if (userPic == null) {
                    profilePic = const AssetImage('assets/images/user.png');
                  } else {
                    profilePic = NetworkImage(userPic);
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: profilePic,
                    ),
                    title: Text(receiverName),
                    subtitle: Text(email),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserChat(
                                    senderId: user!.uid,
                                    receiverId: userId,
                                    receiverName: receiverName,
                                    senderName: senderName,
                                  )));
                    },
                  );
                },
              );
            }
            return const Center(
                child: SpinKitDualRing(
              color: Colors.blue,
              size: 30.0,
            ));
          }),
    );
  }
}
