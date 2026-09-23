import 'package:firebase_auth/firebase_auth.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/data/models/wishlist_item_model.dart';
import 'package:movies_app/features/movie_details/domain/entities/wishlist_item.dart';

class MovieActivityService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppResult<bool>> isFavorite(int movieId) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _requireUser();

      bool exists = false;
      await for (final data in FirestoreService.instance.documentStream<bool>(
        path: _wishlistDocPath(firebaseUser.uid, movieId),
        builder: (_, _) => true,
      )) {
        exists = data ?? false;
        break;
      }
      return exists;
    });
  }

  Future<AppResult<void>> addToWishlist(WishlistItem movie) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _requireUser();

      await FirestoreService.instance.setData(
        path: _wishlistDocPath(firebaseUser.uid, movie.movieId),
        data: WishlistItemModel.fromEntity(movie).toJson(),
        merge: true,
      );
    });
  }

  Future<AppResult<void>> removeFromWishlist(int movieId) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _requireUser();

      await FirestoreService.instance.deleteData(
        path: _wishlistDocPath(firebaseUser.uid, movieId),
      );
    });
  }

  Future<AppResult<void>> recordHistory(WishlistItem movie) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _requireUser();

      await FirestoreService.instance.setData(
        path: _historyDocPath(firebaseUser.uid, movie.movieId),
        data: WishlistItemModel.fromEntity(movie).toJson(),
        merge: true,
      );
    });
  }

  User _requireUser() {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      throw Exception('No authenticated user found.');
    }

    return firebaseUser;
  }

  String _wishlistDocPath(String uid, int movieId) {
    return '${FirestoreCollections.users}/$uid/${FirestoreCollections.wishlist}/$movieId';
  }

  String _historyDocPath(String uid, int movieId) {
    return '${FirestoreCollections.users}/$uid/${FirestoreCollections.history}/$movieId';
  }
}
