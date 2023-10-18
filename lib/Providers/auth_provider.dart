import 'package:flutter/cupertino.dart';
import 'package:todoapp/data_classes/my_users.dart';

class AuthProvider extends ChangeNotifier {
  MyUsers? currentUser;

  void updateUser(MyUsers newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
