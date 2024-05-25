class chatMessages {
  chatMessages({
    required this.toID,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromID,
    required this.mesg,
  });
  late final String toID;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromID;
  late final String mesg;

  chatMessages.fromJson(Map<String, dynamic> json) {
    toID = json['toID'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromID = json['fromID'].toString();
    mesg = json['mesg'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toID'] = toID;
    data['read'] = read;
    data['type'] = type;
    data['sent'] = sent;
    data['fromID'] = fromID;
    data['mesg'] = mesg;
    return data;
  }
}

enum Type {text,image}