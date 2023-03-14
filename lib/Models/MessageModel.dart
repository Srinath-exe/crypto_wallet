class MessageModel {
  final String? senderId;
  final String? recieverid;
  final String? text;
  final MessageType? type;
  final DateTime? timeSent;
  final String? messageId;
  final bool? isSeen;
  final String? repliedMessage;
  final String? repliedTo;
  final String? data;
  final MessageType? repliedMessageType;

  MessageModel({
    this.senderId,
    this.recieverid,
    this.text,
    this.type,
    this.timeSent,
    this.messageId,
    this.isSeen,
    this.repliedMessage,
    this.repliedTo,
    this.repliedMessageType,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type!.type,
      'timeSent': timeSent!.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType!.type,
      "data": data,
    };
  }

  factory MessageModel.fromJson(dynamic map) {
    return MessageModel(
        senderId: map['senderId'] ?? '',
        recieverid: map['recieverid'] ?? '',
        text: map['text'] ?? '',
        type: messageTypetoString[map['type']],
        timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
        messageId: map['messageId'] ?? '',
        isSeen: map['isSeen'] ?? false,
        repliedMessage: map['repliedMessage'] ?? '',
        repliedTo: map['repliedTo'] ?? '',
        repliedMessageType: messageTypetoString[map['repliedMessageType']],
        data: map['data'] ?? '');
  }
}

enum MessageType {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif'),
  plan('plan'),
  date('date'),
  post('post'),
  promotion('promotion'),
  place('place'),
  profile('profile'),
  offers('offers');

  const MessageType(this.type);
  final String type;
}

Map<String, MessageType> messageTypetoString = {
  'text': MessageType.text,
  'image': MessageType.image,
  'audio': MessageType.audio,
  'video': MessageType.video,
  'gif': MessageType.gif,
  'plan': MessageType.plan,
  'date': MessageType.date,
  'post': MessageType.post,
  'promotion': MessageType.promotion,
  'place': MessageType.place,
  'profile': MessageType.profile,
  'offers': MessageType.offers,
};
