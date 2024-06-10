import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/entities/user_entity.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepositoty{
  final FirebaseAuth _firebaseaAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');


  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseaAuth = firebaseAuth ?? FirebaseAuth.instance;

  
  @override
  // TODO: implement user
  Stream<MyUser> get user{
    return _firebaseaAuth.authStateChanges().flatMap((firebaseUser) async*{
      if (firebaseUser == null){
        yield MyUser.empty;
      } else {
        yield await usersCollection
          .doc(firebaseUser.uid)
          .get()
          .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
      }
    });
  }

  
  @override
  Future<void> signIn (String email, String password) async {
    try {
      await _firebaseaAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e){
      log(e.toString());
      rethrow;
    }
  }

  
  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user =  await _firebaseaAuth.createUserWithEmailAndPassword(
        email: myUser.email, 
        password: password);

        myUser.userId = user.user!.uid;
        return myUser;
    } catch (e){
      log(e.toString());
      rethrow;
    }
  }

  
  @override
  Future<void> logOut() async{
    await _firebaseaAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async{
    try {
      await usersCollection
        .doc(myUser.userId)
        .set(myUser.toEntity().toDocument());
    } catch (e){
      log(e.toString());
      rethrow;
    }
  }
 
}