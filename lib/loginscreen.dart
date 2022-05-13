import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyattendance/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = Color(0xffeef444c);

  
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(
                  height: screenHeight / 16,
                )
              : Container(
                  height: screenHeight / 3,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      )),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 5,
                    ),
                  ),
                ),
          Container(
              margin: EdgeInsets.only(
                top: screenHeight / 15,
                bottom: screenWidth / 20,
              ),
              child:
                  Text('Login', style: TextStyle(fontSize: screenWidth / 18))),
          Container(
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldTitle("Employee ID"),
                    customField("Enter your employee id", idController, false),
                    fieldTitle("Password"),
                    customField("Enter your password", passController, true),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String id = idController.text.trim();
                        String password = passController.text.trim();

                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Employee id is still empty!'),
                          ));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Password is still empty!'),
                          ));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection('Employee')
                              .where('id', isEqualTo: id)
                              .get();

                          print(snap.docs[0]['id']);

                          try {
                            if (password == snap.docs[0]['password']) {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();

                              sharedPreferences.setString("'employeeid", id).then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                              });
                              
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Password is not correct!'),
                              ));
                            }
                          } catch (e) {
                            String error = '';
                            print(e.toString());
                            if (e.toString() ==
                                'RangeError (index): Invalid value: Valid value range is empty: 0') {
                              setState(() {
                                error = 'Employee id does not exist';
                              });
                            } else {
                              setState(() {
                                error = 'Error occurred!';
                              });
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('error'),
                            ));

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 40),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        color: primary,
                        child: Center(
                            child: Text(
                          'LOGIN',
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: screenWidth / 26,
                              color: Colors.white),
                        )),
                      ),
                    )
                  ]))
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Text(title, style: TextStyle(fontSize: screenWidth / 26)),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 50),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ]),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(Icons.person, color: primary, size: screenWidth / 15),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: screenWidth / 12),
            child: TextFormField(
              controller: controller,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: screenHeight / 35),
                border: InputBorder.none,
                hintText: hint,
              ),
              maxLines: 1,
              obscureText: obscure,
            ),
          ))
        ],
      ),
    );
  }
}
