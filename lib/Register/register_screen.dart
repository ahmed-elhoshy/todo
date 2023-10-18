import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Home/homeScreen.dart';
import 'package:todoapp/Login/login_screen.dart';
import 'package:todoapp/Providers/auth_provider.dart';
import 'package:todoapp/Reusable_widgets/text_form_field_widget.dart';
import 'package:todoapp/data_classes/my_users.dart';
import 'package:todoapp/dialogUtils.dart';
import 'package:todoapp/firebase_utils.dart';
import 'package:todoapp/mytheme.dart';

class RegisterScreen extends StatefulWidget {
  static const String routename = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'ahmed');

  var emailController = TextEditingController(text: 'ahmed@gmail.com');

  var passwordController = TextEditingController(text: '111111111');

  var confrimationController = TextEditingController(text: '111111111');

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
                        label: 'User Name',
                        controller: nameController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
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
                      TextFormFieldWidget(
                        label: 'Confirm Password',
                        keyboardType: TextInputType.number,
                        controller: confrimationController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            ///trim 3shan lw el user dkhl unused space
                            return 'Please confirm password';
                          }
                          if (text != passwordController.text) {
                            return 'password doesnt match';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            regiester();
                          },
                          child: Text('Register')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.routename);
                          },
                          child: Text('Already have an account ?')),
                    ],
                  ),
                ))
          ],
        ));
  }

  void regiester() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context, 'Loading');
      try {
        var credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        MyUsers user = MyUsers(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);

        await FirebaseUtils.addUserToFireStore(user);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);

        /// listen 3shan el provider m3mool bra el build
        authProvider.updateUser(user);
        DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context, 'Register Successfuly',
            posActionName: 'OK', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
        });
        print('register successful');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              posActionName: 'OK', title: 'Alert !');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, 'The account already exists for that email.',
              posActionName: 'OK', title: 'Alert !');
          print('The account already exists for that email.');
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
