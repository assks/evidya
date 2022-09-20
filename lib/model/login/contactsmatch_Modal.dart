/// body : {"contacts":[{"id":1,"name":"KUNAL PANDEY","phone":"9149252803"},{"id":2,"name":"ARUN JOSHI","phone":"9149252803"},{"id":3,"name":"KUNAL PANDEY","phone":"9149252803"}]}
/// status : "successfull"

class ContactsmatchModal {
  ContactsmatchModal({
    Body body,
    String status,}){
    _body = body;
    _status = status;
  }

  ContactsmatchModal.fromJson(dynamic json) {
    _body = json['body'] != null ? Body.fromJson(json['body']) : null;
    _status = json['status'];
  }
  Body _body;
  String _status;

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

/// contacts : [{"id":1,"name":"KUNAL PANDEY","phone":"9149252803"},{"id":2,"name":"ARUN JOSHI","phone":"9149252803"},{"id":3,"name":"KUNAL PANDEY","phone":"9149252803"}]

class Body {
  Body({
    List<Contacts> contacts,}){
    _contacts = contacts;
  }

  Body.fromJson(dynamic json) {
    if (json['contacts'] != null) {
      _contacts = [];
      json['contacts'].forEach((v) {
        _contacts.add(Contacts.fromJson(v));
      });
    }
  }
  List<Contacts> _contacts;

  List<Contacts> get contacts => _contacts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_contacts != null) {
      map['contacts'] = _contacts.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "KUNAL PANDEY"
/// phone : "9149252803"

class Contacts {
  Contacts({
    int id,
    String name,
    String phone,
    String email}){
    _id = id;
    _name = name;
    _phone = phone;
    _email = email;
  }

  Contacts.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _phone = json['phone'];
    _email = json['email'];

  }
  int _id;
  String _name;
  String _phone;
  String _email;

  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    map['email'] = _email;
    return map;
  }

}