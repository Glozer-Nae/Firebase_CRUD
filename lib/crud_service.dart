import 'package:cloud_firestore/cloud_firestore.dart';

class CrudService { 
  final CollectionReference items = 
  FirebaseFirestore.instance.collection('items');

  Future <void> addItem(String name, int quantity) { 
    
    //CREATE or INSERT
    return items.add({ 
      'name': name, 
      'quantity': quantity,
      'favorite': false,
      'created_at': Timestamp.now(),
    });

  }

  //READ
  Stream<QuerySnapshot> getItems() { 
    return items.orderBy('created_at', descending: true).snapshots();
  }

  //UPDATE
  Future <void> updateItem(String id, String name, int quantity) { 
    return items.doc(id).update({
      'name': name, 
      'quantity': quantity,
    });
  }

  //DELETE

  Future <void> deleteItem(String id) { 
    return items.doc(id).delete();
  }

  //FAVORITE FILTER
  Future<void> toggleFavorite(String id, bool currentValue) async {
  await FirebaseFirestore.instance
      .collection('items')
      .doc(id)
      .update({
    'favorite': !currentValue,
  });
}

}