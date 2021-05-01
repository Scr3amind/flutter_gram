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

  @override
  Future<List<User>> searchUsers({@required String query}) async {
    final userSnap = await _firebaseFirestore
      .collection(Paths.usersCollection)
      .where('username', isGreaterThanOrEqualTo: query)
      .get();
    return userSnap.docs.map(
      (doc) => User.fromDocument(doc)
    ).toList();
  }

  @override
  void followUser({@required String userId, @required String followUserId}) {
    // Add followUser to user's userFollowing.
    _firebaseFirestore
      .collection(Paths.followingCollection)
      .doc(userId)
      .collection(Paths.userFollowingCollection)
      .doc(followUserId)
      .set({});
    // Add user to folllowUser's userFollowers. 
    _firebaseFirestore
      .collection(Paths.followersCollection)
      .doc(followUserId)
      .collection(Paths.userFollowersCollection)
      .doc(userId)
      .set({});
  }

  @override
  void unfollowUser({@required String userId, @required String unfollowUserId}) {
    // Remove unfollowUser from user's userFollowing
    _firebaseFirestore
      .collection(Paths.followingCollection)
      .doc(userId)
      .collection(Paths.userFollowingCollection)
      .doc(unfollowUserId)
      .delete();
    //Remove user from unfollowUser's userFollowers
    _firebaseFirestore
      .collection(Paths.followersCollection)
      .doc(unfollowUserId)
      .collection(Paths.userFollowersCollection)
      .doc(userId)
      .delete();
  }

  @override
  Future<bool> isFollowing({@required String userId, @required String otherUserId}) async {
    final otherUserDoc = await _firebaseFirestore
      .collection(Paths.followingCollection)
      .doc(userId)
      .collection(Paths.userFollowingCollection)
      .doc(otherUserId)
      .get();
    return otherUserDoc.exists;
  }

}