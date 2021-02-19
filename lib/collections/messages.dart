class Collections {
  static get messages => _Messages();
}

class _Messages {
  get name => 'messages';
  get message => 'message';
  get sender => 'sender';
  get timestamp => 'timestamp';
}

class Message {
  String message;
  String sender;
  DateTime dateTime;

  Message({this.sender, this.message, this.dateTime});
}
