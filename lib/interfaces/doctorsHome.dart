import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/MainServices.dart';
import 'chatpage.dart';

class DocHome extends StatefulWidget {
  const DocHome({super.key});

  @override
  State<DocHome> createState() => _DocHomeState();
}

class _DocHomeState extends State<DocHome> {
  final User? user = FirebaseAuth.instance.currentUser;
  late final String? senderName = user!.displayName;
  late final String? senderId = user!.uid;

  @override
  Widget build(BuildContext context) {
    ImageProvider? userPic;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: AllServices.lastChatRoom(senderId, senderName),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return ListTile(
              leading: const CircleAvatar(
                foregroundImage: AssetImage("assets/images/team_small.png"),
                radius: 30.0,
              ),
              title: const Text('Support Group'),
              subtitle: const Text('Join and Interact with everyone at once'),
              trailing:
                  ElevatedButton(onPressed: () {}, child: const Text('Join')),
            );
          }

          final chatRooms = snapshot.data!.docs.reversed.toList();

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoomData =
                  chatRooms[index].data() as Map<String, dynamic>;
              var chatRoomId = chatRooms[index].id;

              return StreamBuilder<QuerySnapshot>(
                stream: AllServices.streamLastMessages(chatRoomId),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.hasData &&
                      messageSnapshot.data!.docs.isNotEmpty) {
                    var lastMessage = messageSnapshot.data!.docs.last.data()
                        as Map<String, dynamic>;
                    String messageText = lastMessage['message'];
                    String sendingId = lastMessage['senderId'];
                    String receiverId = lastMessage['receiverId'];
                    String receiverName = lastMessage['receiverName'];
                    String sendingName = lastMessage['senderName'];
                    String? messageType = lastMessage['messageType'];

                    if (receiverName == senderName) {
                      receiverName = sendingName;
                    }
                    if (receiverId == senderId) {
                      receiverId = sendingId;
                    }

                    if (messageType == 'audio') {
                      messageText = 'Audio';
                    }
                    if (messageType == 'image') {
                      messageText = 'Image';
                    }
                    if (messageType == 'video') {
                      messageText = 'Video';
                    }
                    if (messageType == 'document') {
                      messageText = 'Document';
                    }
                    return StreamBuilder<QuerySnapshot>(
                        stream: AllServices.streamUsers(receiverId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var userData = snapshot.data!.docs.last.data()
                                as Map<String, dynamic>;
                            String? profilePic = userData['profilePic'];
                            if (profilePic == null) {
                              userPic =
                                  const AssetImage('assets/images/user.png');
                            } else {
                              userPic = NetworkImage(profilePic);
                            }
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              foregroundImage: userPic,
                            ),
                            title: Text(receiverName),
                            subtitle: Text(messageText),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserChat(
                                          senderId: user!.uid,
                                          receiverId: receiverId != user!.uid
                                              ? receiverId
                                              : sendingId,
                                          receiverName:
                                              receiverName != user!.displayName
                                                  ? receiverName
                                                  : sendingName,
                                          senderName: senderName,
                                        ))),
                            // Add any other desired information here
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
