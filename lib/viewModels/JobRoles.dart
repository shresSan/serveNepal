import 'package:cloud_firestore/cloud_firestore.dart';

class JobRoles {
  String id;
  String name;
  String pricePerHour;

  JobRoles.fromSnapshot(DocumentSnapshot documentSnapshot) {
    _fromJson(documentSnapshot.data());
  }

  _fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 'default';
    name = json['name'] ?? '';
    pricePerHour = json['price'] ?? '';
  }

  JobRoles.fromJson(Map<String, dynamic> json) {
    _fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name.toUpperCase().trim();
    data['price'] = this.pricePerHour.toUpperCase().trim();
    return data;
  }
  //Future<List<JobRoles>> get prices => firestoreService.getPriceList().first;
}