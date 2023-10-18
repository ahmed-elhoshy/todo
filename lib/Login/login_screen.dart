import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Register/register_screen.dart';
import 'package:todoapp/Reusable_widgets/text_form_field_widget.dart';
import 'package:todoapp/dialogUtils.dart';
import 'package:todoapp/firebase_utils.dart';
import 'package:todoapp/mytheme.dart';

import '../Home/homeScreen.dart';
import '../Providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routename = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'ahmed@gmail.com');

  var passwordController = TextEditingController(text: '111111111');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.limeColor,
        body: Stack(
          children: [
            Image.asset(
              'assets/images/main_background.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      TextFormFieldWidget(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text);
                          if (!emailValid) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldWidget(
                        label: 'password',
                        keyboardType: TextInputType.number,
                        controller: passwordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter password';
                          }

                          if (text.length < 8) {
                            return 'The password cant be less than 8 characters';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text('Login')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.routename);
                          },
                          child: Text('Dont have an account ?')),
                    ],
                  ),
                ))
          ],
        ));
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      ///show loading
      DialogUtils.showLoading(context, 'Loading');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? "");
        if (user == null) {
          return;

          ///  authentication et3mlt bs mtsgltsh fl firebase l ay sabab
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);

        /// listen 3shan el provider m3mool bra el build
        authProvider.updateUser(user);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Login successful',
            posActionName: 'OK', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
        });
        print('Login successful');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'No user found for that email.',
              posActionName: 'OK', title: 'Alert !');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, 'Wrong password provided for that user.',
              posActionName: 'OK', title: 'Alert !');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, '${e.toString()}',
            posActionName: 'OK', title: 'Alert !');
        print(e);
      }
    }
  }
}
