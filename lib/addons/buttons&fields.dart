import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'audio.dart';
import 'video.dart';

///This can be used if you want custom but similar text fields throughout the app
///for number or text fields.
///You can edit it's appearance as desired.
TextFormField defaultField(String text, IconData icon, bool isDigit,
    TextEditingController controller, String unit) {
  return TextFormField(
    controller: controller,
    obscureText: isDigit,
    enableSuggestions: isDigit,
    autocorrect: isDigit,
    cursorHeight: 20.0,
    cursorColor: Colors.black54,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $text';
      }
      return null;
    },
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.blueGrey,
      ),
      suffixText: unit,
      suffixStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          height: 1.0),
      labelText: text,
      labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          height: 1.0),
      filled: true,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.blue, width: 3)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle:
          const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
              width: 3,
              style: BorderStyle.solid,
              color: Colors.blue.withOpacity(0.5))),
    ),
    keyboardType: isDigit ? TextInputType.number : TextInputType.text,
  );
}

///This can be used if you want custom but similar text fields throughout the app
///for password or email fields.
///You can edit it's appearance as desired.
TextFormField otherField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: isPassword == true ? false : true,
    autocorrect: isPassword == true ? false : true,
    cursorHeight: 20.0,
    cursorColor: Colors.black,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $text';
      }
      return null;
    },
    style: TextStyle(
        color: Colors.black.withOpacity(0.9),
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        height: 1.0),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.blueGrey,
      ),
      labelText: text,
      labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.3), fontSize: 16.0, height: 1.0),
      filled: true,
      focusedBorder: OutlineInputBorder(
          gapPadding: 1.0,
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
              color: Colors.green.withOpacity(0.9),
              style: BorderStyle.solid,
              width: 3)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(color: Colors.black54),
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          gapPadding: 1.0,
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
              width: 3,
              style: BorderStyle.solid,
              color: Colors.green.withOpacity(0.9))),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

LayoutBuilder normalField(String hint, bool isDigit,
    TextEditingController controller, Icon icon, Function() function) {
  return LayoutBuilder(builder: (context, constraints) {
    return TextFormField(
      textCapitalization: isDigit == true
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      controller: controller,
      enableSuggestions: isDigit == true ? false : true,
      autocorrect: isDigit == true ? false : true,
      cursorColor: Colors.black,
      cursorHeight: 25.0,
      style: TextStyle(
          color: Colors.black.withOpacity(0.9),
          fontSize: getFontSize(constraints.maxHeight)),
      maxLines: null,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: Colors.grey,
          onPressed: function,
          icon: icon,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 13.0),
        filled: false,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
                color: Colors.blue, width: 2, style: BorderStyle.solid)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.black.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: Colors.black.withOpacity(0.1))),
      ),
      keyboardType: isDigit == true ? TextInputType.number : TextInputType.text,
    );
  });
}

double getFontSize(double height) {
  if (height < 60) {
    return 25.0;
  } else if (height < 90) {
    return 20.0;
  } else {
    return 16.0;
  }
}

///This can be used if you want custom but similar login or signup buttons throughout the app.
///You can edit it as desired.
Container loginSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blueGrey;
            }
            return Colors.green;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      child: Text(
        isLogin ? 'Log In' : 'Sign Up',
        style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

///This can be used if you want custom but similar buttons throughout the app.
///You can edit it as desired.
Container normalButton(BuildContext context, String text, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names, non_constant_identifier_names
///This can be used if you want custom but similar login or signup buttons throughout the app.
///You can edit it as desired.
Container GoogleSignUpButton(
    BuildContext context, IconData icons, bool isGoogle, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton.icon(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blueGrey;
            }
            return Colors.green;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
      icon: Icon(
        icons,
        color: Colors.white,
        size: 30.0,
      ),
      label: Text(
        isGoogle ? 'Sign In With Google' : 'Sign In With Microsoft',
        style: const TextStyle(
            color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Widget userChatBubble(String message, int data, context, String? messageType,
    ImageProvider userPic) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  if (messageType == 'text' || messageType == null) {
    return Padding(
      padding: data == 0
          ? const EdgeInsets.only(bottom: 5.0, right: 15.0)
          : const EdgeInsets.only(bottom: 5.0, left: 15.0),
      child: ChatBubble(
          backGroundColor: data == 0 ? Colors.black87 : Colors.green.shade900,
          clipper: data == 0
              ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 5.0)
              : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 5.0),
          elevation: 3.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                        fontSize: h * 0.02,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          )),
    );
  } else if (messageType == 'audio') {
    return Padding(
      padding: data == 0
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, right: w * 0.1)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, left: w * 0.09),
      child: ChatBubble(
        backGroundColor: data == 0 ? Colors.black87 : Colors.green.shade900,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 15.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 15.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              data != 0
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: userPic,
                    )
                  : const SizedBox(),
              AudioWidget(
                audioUrl: message,
              ),
              data == 0
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: userPic,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  } else if (messageType == 'video') {
    return Padding(
      padding: data == 0
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, right: w * 0.1)
          : EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ChatBubble(
        backGroundColor: data == 0 ? Colors.black87 : Colors.green.shade900,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 15.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 15.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: w * 0.01),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                data == 0 ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                    height: h * 0.5,
                    width: w * 0.8,
                    child: VideoPlayer(videoUrl: message)),
              ),
            ],
          ),
        ),
      ),
    );
  } else if (messageType == 'image') {
    return Padding(
      padding: data == 0
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, right: w * 0.1)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, left: w * 0.09),
      child: ChatBubble(
        backGroundColor: data == 0 ? Colors.black87 : Colors.green.shade900,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 15.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 15.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: w * 0.5,
                height: h * 0.2,
                child: Image.network(
                  message,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } else {
    return Padding(
      padding: data == 0
          ? EdgeInsets.only(top: 5.0, bottom: 5.0, right: w * 0.1)
          : EdgeInsets.only(top: 5.0, bottom: 5.0, left: w * 0.09),
      child: ChatBubble(
        backGroundColor: data == 0 ? Colors.black87 : Colors.green.shade900,
        clipper: data == 0
            ? ChatBubbleClipper4(type: BubbleType.receiverBubble, radius: 15.0)
            : ChatBubbleClipper4(type: BubbleType.sendBubble, radius: 15.0),
        elevation: 3.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                data == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: <Widget>[
              data != 0
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: userPic,
                    )
                  : const SizedBox(),
              AudioWidget(
                audioUrl: message,
              ),
              data == 0
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundImage: userPic,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget contentLoad(double height, double width, String text, String assetName) {
  return Container(
    height: height,
    width: width,
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      image: DecorationImage(fit: BoxFit.cover, image: AssetImage(assetName)),
      color: Colors.black.withOpacity(0.04),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
    child: Text(text),
  );
}

Widget contentLoadingRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      contentLoad(120, 120, '', ''),
      const SizedBox(
        width: 10.0,
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentLoad(20, 120, '', ''),
          const SizedBox(
            height: 10.0,
          ),
          contentLoad(20, 160, '', ''),
          const SizedBox(
            height: 10.0,
          ),
          contentLoad(20, 200, '', ''),
          const SizedBox(
            height: 10.0,
          ),
          contentLoad(20, 180, '', '')
        ],
      ))
    ],
  );
}
