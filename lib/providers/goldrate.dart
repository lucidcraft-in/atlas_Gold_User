// Corrected Goldrate provider with import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// Adjust the path as needed

import 'goldrate_model.dart'; // Correct import path

// Add the correct path to the GoldrateModel file

class Goldrate with ChangeNotifier {
  late FirebaseFirestore _firestore;

  Goldrate() {
    _firestore = FirebaseFirestore.instance;
  }

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('goldrate');

  List<GoldrateModel> _goldRates = [];

  List<GoldrateModel> get goldRates => _goldRates;

  // Fetch Goldrate data from Firestore
  Future getGoldrate() async {
    try {
      QuerySnapshot querySnapshot = await _collectionReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        _goldRates = querySnapshot.docs.map((doc) {
          return GoldrateModel.fromData({
            "id": doc.id,
            ...doc.data() as Map<String, dynamic>, // Merge document fields
          });
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching gold rates: $e");
    }
  }

  // Returns the latest gold rate (example logic)
  GoldrateModel? getLatestGoldrate() {
    if (_goldRates.isNotEmpty) {
      return _goldRates
          .last; // Return the latest one (you can change this logic)
    }
    return null;
  }

  Future<List?> read() async {
    QuerySnapshot querySnapshot;
    List goldaRateList = [];
    try {
      querySnapshot = await _collectionReference.get();
      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        // print("inside read ");
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "gram": doc['gram'],
            "pavan": doc["pavan"],
            "down": doc["down"],
            "up": doc["up"],
            "updateDate": doc["updateDate"],
            "updateTime": doc["updateTime"],
            "18gram": doc["18gram"]
          };
          goldaRateList.add(a);
        }
        print(goldaRateList);
        return goldaRateList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void initialise() {}

  checkPermission() {}
}
