class chatUser {
  chatUser({
    required this.LastSeen,
    required this.CreatedAt,
    required this.Name,
    required this.IsOnline,
    required this.Email,
    required this.Image,
    required this.id,
    required this.About,
    required this.PushToken,
  });
  late final String LastSeen;
  late final String CreatedAt;
  late final String Name;
  late final bool IsOnline;
  late final String Email;
  late final String Image;
  late final String id;
  late final String About;
  late final String PushToken;

  chatUser.fromJson(Map<String, dynamic> json) {
    LastSeen = json['Last_seen'] ?? '';
    CreatedAt = json['Created_at'] ?? '';
    Name = json['Name'] ?? '';
    IsOnline = json['Is_online'] ?? '';
    Email = json['Email'] ?? '';
    Image = json['Image'] ?? '';
    id = json['id'] ?? '';
    About = json['About'] ?? '';
    PushToken = json['Push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Last_seen'] = LastSeen;
    data['Created_at'] = CreatedAt;
    data['Name'] = Name;
    data['Is_online'] = IsOnline;
    data['Email'] = Email;
    data['Image'] = Image;
    data['id'] = id;
    data['About'] = About;
    data['Push_token'] = PushToken;
    return data;
  }
}
