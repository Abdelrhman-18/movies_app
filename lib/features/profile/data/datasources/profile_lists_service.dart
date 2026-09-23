import 'package:firebase_auth/firebase_auth.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/data/models/wishlist_item_model.dart';

class ProfileListsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppResult<List<WishlistItemModel>>> getWishlist() {
    return _getCollection(FirestoreCollections.wishlist);
  }

  Future<AppResult<List<WishlistItemModel>>> getHistory() {
    return _getCollection(FirestoreCollections.history);
  }

  Future<AppResult<List<WishlistItemModel>>> _getCollection(String collection) {
    return FirebaseExecute.call(() async {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found.');
      }

      List<WishlistItemModel> items = [];

      await for (final data
          in FirestoreService.instance.collectionStream<WishlistItemModel>(
            path:
                '${FirestoreCollections.users}/${firebaseUser.uid}/$collection',
            builder: (data, documentId) =>
                WishlistItemModel.fromJson(data, documentId),
          )) {
        items = data;
        break;
      }

      return items;
    });
  }
}
