/// body : {"blocked_connections":[{"id":14,"name":"Piyush kanwal","email":"piyush@shivalikjournal.com","phone":"8791381896","status":"inactive","transit_allowed":"No","profile_image":"users/FxL4ZgvoD4QD9zclwqlcJFiaAJGDYd4agOLwJ2ud.jpeg"}]}
/// status : "successfull"

class Blockuserlist {
  Blockuserlist({
      Body body, 
      String status,}){
    _body = body;
    _status = status;
}

  Blockuserlist.fromJson(dynamic json) {
    _body = json['body'] != null ? Body.fromJson(json['body']) : null;
    _status = json['status'];
  }
  Body _body;
  String _status;
Blockuserlist copyWith({  Body body,
  String status,
}) => Blockuserlist(  body: body ?? _body,
  status: status ?? _status,
);
  Body get body => _body;
  String get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_body != null) {
      map['body'] = _body.toJson();
    }
    map['status'] = _status;
    return map;
  }

}

/// blocked_connections : [{"id":14,"name":"Piyush kanwal","email":"piyush@shivalikjournal.com","phone":"8791381896","status":"inactive","transit_allowed":"No","profile_image":"users/FxL4ZgvoD4QD9zclwqlcJFiaAJGDYd4agOLwJ2ud.jpeg"}]

class Body {
  Body({
      List<BlockedConnections> blockedConnections,}){
    _blockedConnections = blockedConnections;
}

  Body.fromJson(dynamic json) {
    if (json['blocked_connections'] != null) {
      _blockedConnections = [];
      json['blocked_connections'].forEach((v) {
        _blockedConnections.add(BlockedConnections.fromJson(v));
      });
    }
  }
  List<BlockedConnections> _blockedConnections;
Body copyWith({  List<BlockedConnections> blockedConnections,
}) => Body(  blockedConnections: blockedConnections ?? _blockedConnections,
);
  List<BlockedConnections> get blockedConnections => _blockedConnections;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_blockedConnections != null) {
      map['blocked_connections'] = _blockedConnections.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 14
/// name : "Piyush kanwal"
/// email : "piyush@shivalikjournal.com"
/// phone : "8791381896"
/// status : "inactive"
/// transit_allowed : "No"
/// profile_image : "users/FxL4ZgvoD4QD9zclwqlcJFiaAJGDYd4agOLwJ2ud.jpeg"

class BlockedConnections {
  BlockedConnections({
      int id, 
      String name, 
      String email, 
      String phone, 
      String status, 
      String transitAllowed, 
      String profileImage,}){
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _status = status;
    _transitAllowed = transitAllowed;
    _profileImage = profileImage;
}

  BlockedConnections.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _status = json['status'];
    _transitAllowed = json['transit_allowed'];
    _profileImage = json['profile_image'];
  }
  int _id;
  String _name;
  String _email;
  String _phone;
  String _status;
  String _transitAllowed;
  String _profileImage;
BlockedConnections copyWith({  int id,
  String name,
  String email,
  String phone,
  String status,
  String transitAllowed,
  String profileImage,
}) => BlockedConnections(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  phone: phone ?? _phone,
  status: status ?? _status,
  transitAllowed: transitAllowed ?? _transitAllowed,
  profileImage: profileImage ?? _profileImage,
);
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get status => _status;
  String get transitAllowed => _transitAllowed;
  String get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone'] = _phone;
    map['status'] = _status;
    map['transit_allowed'] = _transitAllowed;
    map['profile_image'] = _profileImage;
    return map;
  }

}