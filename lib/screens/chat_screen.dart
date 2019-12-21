import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:intl/intl.dart';

final _firestore = Firestore.instance;
FirebaseUser currentUser;

class ChatScreen extends StatefulWidget {
  static String route = "/chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String message;
  TextEditingController messageController = TextEditingController();

  void getCurrentUser() async {
    try {
      var _currentUser = await _auth.currentUser();
      if (_currentUser != null) {
        currentUser = _currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut().whenComplete(() {
                  Navigator.pop(context);
                });
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: kBackgroundBoxDecoration,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageController.clear();
                        _firestore.collection("messages").add({
                          "sender": currentUser.email,
                          "text": message,
                          "creationTime": DateTime.now()
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("messages")
            .orderBy("creationTime")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data.documents.reversed;

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              children: messages.map((message) {
                String sender = message.data["sender"];
                String text = message.data["text"];
                DateTime creationTime = message.data["creationTime"].toDate();
                bool isCurrentUser = currentUser.email == sender;
                return MessageBubble(
                  text: text,
                  sender: sender,
                  isCurrentUser: isCurrentUser,
                  creationTime: creationTime,
                );
              }).toList(),
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.text,
    @required this.sender,
    this.isCurrentUser,
    this.creationTime,
  }) : super(key: key);

  final DateTime creationTime;
  final String text;
  final String sender;
  final bool isCurrentUser;

  String formatDate() {
    var formatter = new DateFormat('dd.MM.yyyy hh:mm');
    return formatter.format(creationTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              "$sender at ${formatDate()}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: isCurrentUser ? 8.0 : 0,
              left: isCurrentUser ? 0 : 8.0,
            ),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isCurrentUser ? 30.0 : 0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(isCurrentUser ? 0 : 30.0),
              ),
              color:
                  isCurrentUser ? Colors.lightBlueAccent : Colors.orangeAccent,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
