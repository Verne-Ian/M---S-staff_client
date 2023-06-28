import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universal_html/html.dart' as html;

class Login {
  String userID;
  String passcode;

  Login({required this.userID, required this.passcode});

  static phoneLogin(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static Future<User?> googleLogin() async {
    if (kIsWeb) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Trigger the authentication flow
      try {
        // Trigger the authentication flow with redirect
        await _auth.signInWithRedirect(googleProvider);

        // Wait for the redirect to complete
        final UserCredential userCredential = await _auth.getRedirectResult();

        // Return the user object
        return userCredential.user;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      //beginning the sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //Obtaining the Authentication details from the Google sign in Request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //Creates a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      //This will sign in the user
      final appUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = appUser.user;

      if (user != null) {
        // Save additional user data to Firestore
        await FirebaseFirestore.instance
            .collection('Staff_Users')
            .doc(user.uid)
            .set({
          'UserId': user.uid,
          'Name': user.displayName,
          'Email': user.email,
          'ProfilePic': user.photoURL,
          'Role': 'Staff'
          // Add more fields as needed
        });
      }

      return appUser.user;
    }
  }

  static Future<void> emailLogin(
      TextEditingController emailControl,
      TextEditingController passControl,
      String email,
      String password,
      BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: SpinKitDualRing(
                color: Colors.white70,
                size: 30.0,
              ),
            );
          });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (FirebaseAuth.instance.currentUser!.photoURL != null &&
            FirebaseAuth.instance.currentUser!.displayName != null) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, '/addProfilePic');
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('User Not Found'),
              );
            });
        emailControl.text = '';
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
        passControl.text = '';
      }
    }
  }

  static Future<void> createWithEmail(
      TextEditingController nameControl,
      TextEditingController emailControl,
      TextEditingController passControl,
      String name,
      String email,
      String password,
      BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: SpinKitDualRing(
                color: Colors.white70,
                size: 30.0,
              ),
            );
          });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.updateDisplayName(name).then((value) async {
            // Save additional user data to Firestore
            await FirebaseFirestore.instance
                .collection('Staff_Users')
                .doc(user.uid)
                .set({
              'UserId': user.uid,
              'Name': user.displayName,
              'Email': user.email,
              'ProfilePic': user.photoURL,
              'Role': 'Staff'
            });
          });
        }
        if (FirebaseAuth.instance.currentUser!.photoURL != null &&
            FirebaseAuth.instance.currentUser!.displayName != null) {
          // ignore: use_build_context_synchronously
          return Navigator.pop(context);
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/addProfilePic');
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('User Not Found'),
              );
            });
        emailControl.text = '';
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
        passControl.text = '';
      }
    }
  }
}

class MyUser {
  late String _id;
  late String _name;
  late String _imageUrl;

  MyUser({required String id, required String name, required String imageUrl})
      : _id = id,
        _name = name,
        _imageUrl = imageUrl;

  factory MyUser.fromFirebaseUser(User firebaseUser) {
    return MyUser(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      imageUrl: firebaseUser.photoURL ?? '',
    );
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}

class AllServices {
  // Function for selecting or taking a profile picture
  static Future<String?> selectProfilePicture(
      BuildContext context, html.File? pickedFile, String userName) async {
    if (pickedFile == null) {
      print('No image selected.');
      return null;
    }
    final imageData = pickedFile;

    try {
      final storageRef = FirebaseStorage.instance
          .ref('profile_pics/${FirebaseAuth.instance.currentUser!.uid}.jpg');

      final uploadTask = storageRef.putBlob(
        imageData, // Cast to Blob type
        SettableMetadata(contentType: imageData.type), // Set the content type
      );

      final snapshot = await uploadTask.whenComplete(() => null);

      // Get image URL from Firebase Storage
      final url = await snapshot.ref.getDownloadURL();

      // Update user profile picture in Firebase Auth
      final user = FirebaseAuth.instance.currentUser!;
      await user.updatePhotoURL(url.toString());
      await user.updateDisplayName(userName);

      // Update user profile picture in Firestore
      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('Staff_Users').doc(user.uid);
      await userDocRef.update({'ProfilePic': url, 'Name': userName}).then(
          (value) => Navigator.pushReplacementNamed(context, '/home'));

      return url.toString();
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  static late String? chatRoomId;

  static Future<void> createChatRoom(
      List<Map<String, String?>> participants) async {
    CollectionReference chatRooms =
        FirebaseFirestore.instance.collection('ChatRooms');

    try {
      // Sort participant IDs to ensure consistent document ID generation
      List<String?> participantIds =
          participants.map((participant) => participant['id']).toList()..sort();

      // Generate a unique chat room ID based on sorted participant IDs
      chatRoomId = participantIds.join('_');

      final chatRoomRef = chatRooms.doc(chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();

      if (!chatRoomSnapshot.exists) {
        await chatRoomRef.set(
          {
            'participants': participants,
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    } catch (error) {
      print('Error creating chat room: $error');
      rethrow;
    }
  }

  static Future<void> sendMessageToChatRoom(
    String chatRoomId,
    String senderId,
    String? senderName,
    String receiverId,
    String receiverName,
    String message,
    String? audioFilePath,
    String? imageFilePath,
    String? videoFilePath,
    String? documentFilePath,
  ) async {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    try {
      if (audioFilePath != '') {
        // Handle audio message
        String audioUrl = await uploadAudioMessage(
            audioFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'audio', // Indicate it's an audio message
          'message': audioUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance
            .collection('ChatRooms')
            .doc(chatRoomId)
            .set(
          {
            'lastMessage': {
              'message': audioUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      } else if (imageFilePath != '') {
        String imageUrl = await uploadImageMessage(
            imageFilePath!); // Upload image file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'image', // Indicate it's an image message
          'message': imageUrl, // Store the URL of the image file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance
            .collection('ChatRooms')
            .doc(chatRoomId)
            .set(
          {
            'lastMessage': {
              'message': imageUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      } else if (videoFilePath != '') {
        // Handle sending video message

        String videoUrl = await uploadVideoMessage(
            videoFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'video', // Indicate it's an audio message
          'message': videoUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance
            .collection('ChatRooms')
            .doc(chatRoomId)
            .set(
          {
            'lastMessage': {
              'message': videoUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      } else if (documentFilePath != '') {
        // Handle sending document message
        String documentUrl = await uploadDocumentMessage(
            documentFilePath!); // Upload audio file to Firebase Storage
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'document', // Indicate it's an audio message
          'message': documentUrl, // Store the URL of the audio file
          'timestamp': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance
            .collection('ChatRooms')
            .doc(chatRoomId)
            .set(
          {
            'lastMessage': {
              'message': documentUrl,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      } else {
        // Handle text message
        await chatRoomCollection.add({
          'senderId': senderId,
          'senderName': senderName,
          'receiverId': receiverId,
          'receiverName': receiverName,
          'messageType': 'text', // Indicate it's a text message
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update the last message in the chat room
        await FirebaseFirestore.instance
            .collection('ChatRooms')
            .doc(chatRoomId)
            .set(
          {
            'lastMessage': {
              'message': message,
              'senderId': senderId,
              'receiverId': receiverId,
              'receiverName': receiverName,
              'senderName': senderName,
              'timestamp': FieldValue.serverTimestamp(),
            },
          },
          SetOptions(merge: true),
        );
      }
    } catch (error) {
      print('Error sending message: $error');
      rethrow;
    }
  }

  static Future<String> uploadVideoMessage(var videoFilePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('chat_videos')
        .child('${DateTime.now().millisecondsSinceEpoch}.mp4');
    UploadTask uploadTask = storageReference.putFile(videoFilePath);
    await uploadTask.whenComplete(() {});
    String videoUrl = await storageReference.getDownloadURL();
    return videoUrl;
  }

  // Function for saving a document message to Firebase Storage
  static Future<String> uploadDocumentMessage(var documentFilePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('document_messages')
        .child('${DateTime.now().millisecondsSinceEpoch}.pdf');
    UploadTask uploadTask = storageReference.putFile(documentFilePath);
    await uploadTask.whenComplete(() {});
    String documentUrl = await storageReference.getDownloadURL();
    return documentUrl;
  }

  static Future<String> uploadAudioMessage(audioFilePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('audio_messages')
        .child('${DateTime.now().millisecondsSinceEpoch}.m4a');
    UploadTask uploadTask = storageReference.putFile(audioFilePath);
    await uploadTask.whenComplete(() {});
    String audioUrl = await storageReference.getDownloadURL();
    return audioUrl;
  }

  // Function for saving an image message to Firebase Storage
  static Future<String> uploadImageMessage(var imageFilePath) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('image_messages')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageReference.putFile(imageFilePath);
    await uploadTask.whenComplete(() {});
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  static Stream<QuerySnapshot> streamUserChatRoom(
      String? userId, String? userName) {
    return FirebaseFirestore.instance.collection('ChatRooms').where(
        'participants',
        arrayContains: {'id': userId, 'name': userName}).snapshots();
  }

  static Stream<QuerySnapshot> lastChatRoom(String? userId, String? userName) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('participants', arrayContains: {'id': userId, 'name': userName})
        .orderBy('lastMessage.timestamp', descending: false)
        .snapshots();
  }

  // Function to stream query snapshot of user data from Firestore

  static Stream<QuerySnapshot> streamUser(String? userId) {
    return FirebaseFirestore.instance
        .collection('Staff_Users')
        .where('UserId', isEqualTo: userId)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamLastMessages(String? chatRoomId) {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    return chatRoomCollection
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot> streamMessages(String? chatRoomId) {
    CollectionReference chatRoomCollection = FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Chat_Messages');

    return chatRoomCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class Message {
  late String id;
  late String text;
  late String imageUrl;
  final MyUser sender;
  final Timestamp time;

  Message({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'sender': {
        'id': sender._id,
        'name': sender._name,
        'imageUrl': sender._imageUrl,
      },
      'time': time,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    final senderMap = map['sender'] as Map<String, dynamic>;
    final sender = MyUser(
      id: senderMap['id'],
      name: senderMap['name'],
      imageUrl: senderMap['imageUrl'],
    );

    return Message(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      sender: sender,
      time: map['time'],
    );
  }
}

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late MyUser _currentUser;
  List<Message> _messages = [];

  ChatProvider() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _currentUser = MyUser.fromFirebaseUser(user);
      }
    });
  }

  MyUser get currentUser => _currentUser;
  List<Message> get messages => _messages;
  FirebaseStorage get _storage => FirebaseStorage.instance;

  void loadMessages() {
    _db.collection('messages').orderBy('time').snapshots().listen((snapshot) {
      _messages =
          snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
      notifyListeners();
    });
  }
}
