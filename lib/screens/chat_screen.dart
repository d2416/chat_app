import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_app/collections/messages.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static final String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
      TextEditingController(); // to control the input field in the chat
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
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
        print(loggedInUser.email);
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
                      _firestore.collection(Messages.name).add({
                        Messages.sender: loggedInUser.email,
                        Messages.message: message,
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
      stream: _firestore.collection(Messages.name).snapshots(),
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
          final String msg = doc.get(Messages.message);
          final String sender = doc.get(Messages.sender);

          messageBubbles.add(
            MessageBubble(message: msg, sender: sender),
          );
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: ListView(
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.message,
    @required this.sender,
  });

  final String message;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(24.0),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                '$message',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
