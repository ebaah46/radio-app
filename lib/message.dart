// import 'dart:html';

class Message {
  int statusCode;
  List<Data> data;
  Null error;
  Message({this.data, this.statusCode, this.error});
  factory Message.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as List;
    List<Data> dataList = data.map((f) => Data.fromJson(f)).toList();
    return Message(
        data: dataList,
        error: json['error'] as Null,
        statusCode: json['status_code'] as int);
  }
}

class Data {
  int id;
  String title;
  String description;
  String author;
  String date;
  String picture;
  String message;

  Data(
      {this.author,
      this.date,
      this.description,
      this.id,
      this.message,
      this.picture,
      this.title});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        author: json['author'] as String,
        date: json['date'] as String,
        description: json['description'] as String,
        id: json['id'] as int,
        message: json['message_file'] as String,
        picture: json['message_picture'] as String,
        title: json['title'] as String);
  }
}
