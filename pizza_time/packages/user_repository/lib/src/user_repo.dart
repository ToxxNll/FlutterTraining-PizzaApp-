import 'models/models.dart';

abstract class UserRepositoty{

  Stream <MyUser> get user;

  Future <MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void>signIn(String email, String password);
  
  Future<void> logOut();

}