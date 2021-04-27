import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gram/config/paths.dart';
import 'package:flutter_gram/models/post_model.dart';
import 'package:flutter_gram/models/comment_model.dart';
import 'package:flutter_gram/repositories/post/base_post_repository.dart';
import 'package:meta/meta.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({@required Post post}) async {
    await _firebaseFirestore.collection(Paths.postCollection).add(post.toDocument());
  }

  @override
  Future<void> createComment({@required Comment comment}) async {
    await _firebaseFirestore
      .collection(Paths.commentsCollection)
      .doc(comment.id)
      .collection(Paths.postCommentsCollection)
      .add(comment.toDocument());
  }

  @override
  Stream<List<Future<Post>>> getUserPosts({@required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.usersCollection).doc(userId);
    final userPostSnapshots = _firebaseFirestore
      .collection(Paths.postCollection)
      .where('author', isEqualTo: authorRef)
      .orderBy('date', descending: true)
      .snapshots();
    return userPostSnapshots.map((snap) => 
      snap.docs.map((doc) => Post.fromDocument(doc)).toList()
    );
  }

  @override
  Stream<List<Future<Comment>>> getPostComments({@required String postId}) {
    final postCommentsSnapshots = _firebaseFirestore
      .collection(Paths.commentsCollection)
      .doc(postId)
      .collection(Paths.postCommentsCollection)
      .orderBy('date', descending: false)
      .snapshots();
    return postCommentsSnapshots.map((snap) => 
      snap.docs.map((doc) => Comment.fromDocument(doc)).toList()
    );

  }

}