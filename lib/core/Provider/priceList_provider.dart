import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Services/Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';

class PriceListProvider with ChangeNotifier {
  Services firestoreService = Services();
  String _id;
  String _name;
  String _pricePerHour;

  //Getters
  String get id => _id;
  String get name => _name;
  String get pricePerHour => _pricePerHour;
  Stream<List<JobRoles>> get priceList => firestoreService.getPriceList();

  //Setters
  set setId(String id){
    _id = id;
    notifyListeners();
  }

  set setName(String name){
    _name = name;
    notifyListeners();
  }
  set setJobShift(String pricePerHour){
    _pricePerHour = pricePerHour;
    notifyListeners();
  }

  //Functions
  loadPriceList(List<JobRoles> priceList) {
    for (int i = 0; i < priceList.length; i++) {
      _id = priceList[i].id;
      _name = priceList[i].name;
      _pricePerHour = priceList[i].pricePerHour;
    }
  }
}