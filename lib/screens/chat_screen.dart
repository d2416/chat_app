import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_app/collections/messages.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
ScrollController _scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  static final String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
      TextEditingController(); // to control the input field in the chat
  final _auth = FirebaseAuth.instance;
  String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    try {
      final User user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      } else {
        throw FirebaseAuthException;
      }
    } catch (e) {
      print(e);
    }
  }

  /// Used to get all the message from the 'messages' Collection
  getMessages() async {
    final messages = await _firestore.collection('messages').get();

    for (var msg in messages.docs) {
      print(msg.get('message'));
    }
  }

  /// Used to subscribe to the snapshots 'service' and being notified
  /// every time a new message is added to the collection
  messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    }
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
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController, // add controller
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection(Collections.messages.name).add({
                        Collections.messages.sender: loggedInUser.email,
                        Collections.messages.message: message,
                        Collections.messages.timestamp: DateTime.now(),
                      }).then((value) {
                        print("value: $value");
                        messageTextController
                            .clear(); // clean text field after sending the message
                      }).catchError((error) => print("error: $error"));
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
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(Collections.messages.name)
          .orderBy(Collections.messages.timestamp)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            // use progress 'bar' while retrieving data
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              backgroundColor: Colors.grey,
              strokeWidth: 3,
            ),
          );
        }

        List<MessageBubble> messageBubbles = [];
        for (var doc in snapshot.data.docs) {
          Message msg = Message(
            message: doc.get(Collections.messages.message),
            sender: doc.get(Collections.messages.sender),
            dateTime: doc.get(Collections.messages.timestamp).toDate(),
          );

          final String currentUser = loggedInUser.email;

          messageBubbles.add(
            MessageBubble(
              message: msg,
              isMe: currentUser == msg.sender,
            ),
          );
        }

        if (messageBubbles.length > 0)
          Timer(
              Duration(milliseconds: 300),
              () => _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent));

        return Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.message,
    this.isMe,
  });

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '${message.sender}',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  )
                : message.sender == 'init'
                    ? BorderRadius.all(
                        Radius.circular(30.0),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                '${message.message}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
