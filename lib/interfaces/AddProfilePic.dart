import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:m_n_s_staff_client/addons/buttons&fields.dart';

import '../services/MainServices.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({Key? key}) : super(key: key);

  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {
  html.File? imageFile;
  TextEditingController _nameController = TextEditingController();
  late ImageProvider userPic = const AssetImage('assets/images/user.png');
  late MemoryImage sendImage;

  Future<void> _selectImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          setState(() {
            imageFile = file;
            final imageData = reader.result as String;
            final bytes = base64Decode(imageData.split(',').last);
            sendImage = MemoryImage(Uint8List.fromList(bytes));
            userPic = sendImage;
          });
        });

        reader.readAsDataUrl(file);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile Picture'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: userPic,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _selectImage();
                },
                child: const Text('Select from Gallery'),
              ),
              const SizedBox(
                width: 20.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultField('Enter Your Name', Icons.verified_user, false,
                  _nameController, ''),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  imageFile == null
                      ? showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('No Image Selected'),
                            );
                          })
                      : AllServices.selectProfilePicture(
                          context, imageFile, _nameController.text);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
