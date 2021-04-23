import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gram/config/paths.dart';
import 'package:flutter_gram/models/user_model.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:meta/meta.dart';

class UserRepository extends BaseUserRepository {

  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore}) 
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance; 

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc = await _firebaseFirestore.collection(Paths.usersCollection).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    await _firebaseFirestore
      .collection(Paths.usersCollection)
      .doc(user.id)
      .update(user.toDocument());
  }

}