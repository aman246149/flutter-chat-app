class Message {
  String? message;
  String? sender;
  String? receiverStatus;
  String? senderStatus;
  String? receiver;
  num? timestamp;

  Message({
    this.message,
    this.sender,
    this.receiverStatus,
    this.senderStatus,
    this.receiver,
    this.timestamp,
  });

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    sender = json['sender'];
    receiverStatus = json['receiverStatus'];
    senderStatus = json['senderStatus'];
    receiver = json['receiver'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['sender'] = sender;
    data['receiverStatus'] = receiverStatus;
    data['senderStatus'] = senderStatus;
    data['receiver'] = receiver;
    data['timestamp'] = timestamp;
    return data;
  }
}
