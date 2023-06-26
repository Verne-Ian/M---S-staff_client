import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import '../addons/buttons&fields.dart';
import '../services/MainServices.dart';
import '../services/audio_service.dart';

class UserChat extends StatefulWidget {
  final String? senderName;
  final String senderId;
  final String receiverId;
  final String receiverName;
  const UserChat(
      {Key? key,
      required this.senderId,
      required this.receiverId,
      required this.receiverName,
      required this.senderName})
      : super(key: key);

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  TextEditingController messageText = TextEditingController();
  String? chatRoomId = '86fo7to086d6dugvko6';
  late Stream<QuerySnapshot> messageStream =
      AllServices.streamMessages('kfluy86lcutcltxtx');
  bool recording = false;
  final User? user = FirebaseAuth.instance.currentUser;
  late String filePath;
  File? _imageFile;
  File? _mediaFile;

  // Function to select a video file
  Future<String?> selectVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String? filePath = file.path;
        return filePath;
      } else {
        // User canceled the file picker
        return null;
      }
    } catch (e) {
      // Handle any potential exceptions
      print('Error selecting audio file: $e');
      return null;
    }
  }

  // Function to select an audio file
  Future<String?> selectAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String? filePath = file.path;
        return filePath;
      } else {
        // User canceled the file picker
        return null;
      }
    } catch (e) {
      // Handle any potential exceptions
      print('Error selecting audio file: $e');
      return null;
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to call the showMenu function
  Future showMenuCall() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(w * 0.4, h * 0.65, 1, 30),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Ionicons.videocam_outline),
            title: Text('Video'),
            onTap: () {
              selectVideoFile().then((value) {
                if (value != null) {
                  setState(() {
                    filePath = value;
                    _mediaFile = File(filePath);
                  });
                  AllServices.sendMessageToChatRoom(
                      chatRoomId!,
                      widget.senderId,
                      widget.senderName,
                      widget.receiverId,
                      widget.receiverName,
                      '',
                      '',
                      '',
                      _mediaFile!.path,
                      '');
                }
              });
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              _selectImage(ImageSource.gallery);
            },
            leading: Icon(Ionicons.image_outline),
            title: Text('Image'),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              _selectImage(ImageSource.camera);
            },
            leading: const Icon(Ionicons.camera_outline),
            title: Text('Camera'),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              selectAudioFile().then((value) {
                if (value != null) {
                  setState(() {
                    filePath = value;
                    _mediaFile = File(filePath);
                  });
                  AllServices.sendMessageToChatRoom(
                      chatRoomId!,
                      widget.senderId,
                      widget.senderName,
                      widget.receiverId,
                      widget.receiverName,
                      '',
                      _mediaFile!.path,
                      '',
                      '',
                      '');
                }
              });
            },
            leading: const Icon(Ionicons.musical_notes_outline),
            title: const Text('Audio'),
          ),
        ),
      ],
    );
  }

  participants() async {
    List<Map<String, String?>> chatParticipants = [
      {'id': widget.senderId, 'name': widget.senderName},
      {'id': widget.receiverId, 'name': widget.receiverName}
    ];

    await AllServices.createChatRoom(chatParticipants);

    String? newChatRoomId = AllServices.chatRoomId;

    if (chatRoomId != newChatRoomId || chatRoomId == null) {
      setState(() {
        chatRoomId = newChatRoomId!;
        messageStream = AllServices.streamMessages(chatRoomId);
      });
    }
  }

  void startRecord() async {
    String thePath = (await AudioService.getFilePath())!;
    setState(() {
      filePath = thePath;
      recording = true;
    });
    AudioService.startRecording(filePath);
  }

  void sendAudio() async {
    AllServices.sendMessageToChatRoom(
        chatRoomId!,
        widget.senderId,
        widget.senderName,
        widget.receiverId,
        widget.receiverName,
        '',
        filePath,
        '',
        '',
        '');
  }

  void sendImage() async {
    AllServices.sendMessageToChatRoom(
        chatRoomId!,
        widget.senderId,
        widget.senderName,
        widget.receiverId,
        widget.receiverName,
        '',
        '',
        _imageFile!.path,
        '',
        '');
  }

  void sendMessage() async {
    String message = messageText.text.trim();

    if (message.isNotEmpty) {
      AllServices.sendMessageToChatRoom(
              chatRoomId!,
              widget.senderId,
              widget.senderName,
              widget.receiverId,
              widget.receiverName,
              message,
              '',
              '',
              '',
              '')
          .then((value) {
        messageText.clear();
      }).catchError((error) {
        print('Error sending message: $error');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    participants();
  }

  @override
  void dispose() {
    messageText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? profilePic = user!.photoURL;
    ImageProvider userPic;
    if (profilePic == null) {
      userPic = const AssetImage('assets/images/user.png');
    } else {
      userPic = NetworkImage(profilePic);
    }

    //This will retrieve the screen size of the device.
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: Nothing');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: SizedBox(
                      width: w * 0.95,
                      height: h * 0.3,
                      child: SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          color: Colors.white,
                          elevation: 10.0,
                          shadowColor: Colors.black.withOpacity(0.5),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    w * 0.1, h * 0.1, w * 0.1, h * 0.02),
                                child: const Text(
                                  'No messages!',
                                  style: TextStyle(fontSize: 25.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var messageData = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        var message = messageData['message'] ?? '';
                        var messageType = messageData['messageType'];
                        var data =
                            messageData['senderId'] == widget.senderId ? 1 : 0;
                        return userChatBubble(
                            message, data, context, messageType, userPic);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            color: _imageFile != null
                ? Colors.blue.withOpacity(0.3)
                : Colors.white,
            padding: EdgeInsets.only(
                left: 8.0, right: 8.0, top: h * 0.01, bottom: h * 0.01),
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            child: Column(
              children: [
                _imageFile != null
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: h * 0.01,
                            bottom: h * 0.01),
                        width: w * 0.7,
                        height: h * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Image.file(_imageFile!))
                    : Container(),
                SizedBox(
                  height: h * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: normalField(
                            'Add Message',
                            false,
                            messageText,
                            Icon(
                              Icons.attach_file,
                            ),
                            showMenuCall)),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    recording == true
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                              icon: const Icon(
                                Icons.stop,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // handle the second button press
                                setState(() {
                                  recording = false;
                                });
                                AudioService.stopRecording()
                                    .then((value) => sendAudio());
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade500,
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                              icon: const Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                startRecord();
                              },
                            ),
                          ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(
                                color: Colors.white,
                                Icons.send_outlined,
                                size: 25.0,
                              ),
                              onPressed: () {
                                if (messageText.text.isEmpty &&
                                    _imageFile!.path == null) {
                                  print("empty message");
                                } else if (messageText.text.isNotEmpty) {
                                  sendMessage();
                                  messageText.clear();
                                } else if (_imageFile!.path != null) {
                                  sendImage();
                                  setState(() {
                                    _imageFile = null;
                                  });
                                }
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
