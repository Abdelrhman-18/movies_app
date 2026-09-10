import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  void _log(String message) {
    if (kDebugMode) debugPrint('[FirestoreService] $message');
  }

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestore.doc(path);
    _log('setData -> $path: $data');
    try {
      await reference.set(data, SetOptions(merge: merge));
    } on FirebaseException catch (e) {
      _log('setData failed [$path]: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    _log('addData -> $path: $data');
    try {
      final reference = await firestore.collection(path).add(data);
      return reference.id;
    } on FirebaseException catch (e) {
      _log('addData failed [$path]: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<void> deleteData({required String path}) async {
    final reference = firestore.doc(path);
    _log('deleteData -> $path');
    try {
      await reference.delete();
    } on FirebaseException catch (e) {
      _log('deleteData failed [$path]: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T? Function(Map<String, dynamic> data, String documentId) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)?
    queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query
        .snapshots()
        .handleError((Object error) {
          _log('collectionStream error [$path]: $error');
          throw error;
        })
        .map((snapshot) {
          final result = snapshot.docs
              .map((doc) => builder(doc.data(), doc.id))
              .where((value) => value != null)
              .cast<T>()
              .toList();
          if (sort != null) {
            result.sort(sort);
          }
          return result;
        });
  }

  Stream<T?> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = firestore.doc(path);
    return reference
        .snapshots()
        .handleError((Object error) {
          _log('documentStream error [$path]: $error');
          throw error;
        })
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) return null;
          return builder(data, snapshot.id);
        });
  }
}
