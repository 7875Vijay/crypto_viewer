import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:crypto_viewer/pages/crypto_view_sreen.dart';
import 'package:crypto_viewer/pages/register_view_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //AuthenticationHelper().isAuthenticated(context);
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  Future <bool> setData(var data) async{
    bool isOk = false;
     await AuthenticationHelper().signIn(email: data["email"], password: data["pass"]).then((result) {
      if (result == null) {
        print("-------------------Login True----------------- \n\n");
        isOk = true;
      }
      else{
        print("-------------------Login Fail-----------------> ${result} \n\n");
        isOk = false;
      }
    });
     return isOk;
  }
  // Future<void> getData() async {
  //   ref.onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value;
  //     print('-----------------------------------------------------------\n\n\n ${data}\n\n\n\n\n');
  //     //updateStarCount(data);
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formkey, // Assigning GlobalKey<FormState> to Form widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100.0),
                  Center(
                    child: ClipOval(
                      child: Icon(
                        CupertinoIcons.profile_circled,
                        size: 100,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color:Colors.grey[900],
                        ),
                        hintText: 'abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                      ),
                      style: TextStyle(
                        color:Colors.grey[900],
                        fontSize: 20.0,
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "* Required"),
                        EmailValidator(errorText: "Enter valid email id"),
                      ]),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: passController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey[900],
                        ),
                        hintText: '******',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[900],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 20.0,
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "* Required"),
                        MinLengthValidator(
                            6, errorText: "Password should be atleast 6 characters"),
                        MaxLengthValidator(
                            15, errorText: "Password should not be greater than 15 characters")
                      ]),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Please register new user ", style: TextStyle(color: Colors.grey[900]),),
                      TextButton(onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      }, child: Text("Click", style: TextStyle(color: Colors.grey[900]))),

                    ],),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        border: BoxDecoratinStyes.CustomeBorder,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: Colors.grey[300]!,
                            offset: Offset(3.0, 4.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),



                      child: Container(
                        height: 150,
                        child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                )
                              ),
                              onPressed: () async {
                                bool isOk = false;
                                if (formkey.currentState!.validate()) {
                                  final email = emailController.text;
                                  final pass = passController.text;
                                  var map = {};
                                  map['email'] = email;
                                  map['pass'] = pass;
                                  isOk = await setData(map);
                                  print("-----------------------$isOk----------------------");
                                  // do something with the form data
                                }
                                if(isOk){
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor:Colors.green[700],
                                      title: const Text("Success", style: TextStyle(color: Colors.white)),
                                      content: const Text("User login successfully", style: TextStyle(color: Colors.white)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("okay"),
                                            decoration: BoxDecoration(
                                              color: Colors.green[400]!,
                                              borderRadius: BorderRadius.circular(25.0),
                                              border: BoxDecoratinStyes.CustomeBorder,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green[200]!,
                                                  offset: Offset(-4.0, -4.0),
                                                  blurRadius: 5.0,
                                                  spreadRadius: 2.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.green[700]!,
                                                  offset: Offset(3.0, 4.0),
                                                  blurRadius: 5.0,
                                                  spreadRadius: 2.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CryptoViewScreen()));

                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor:Colors.red[700],
                                      title: const Text("Fail", style: TextStyle(color: Colors.white)),
                                      content: const Text("User not found", style: TextStyle(color: Colors.white)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("okay"),
                                            decoration: BoxDecoration(
                                              color: Colors.red[400]!,
                                              borderRadius: BorderRadius.circular(25.0),
                                              border: BoxDecoratinStyes.CustomeBorder,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red[200]!,
                                                  offset: Offset(-4.0, -4.0),
                                                  blurRadius: 5.0,
                                                  spreadRadius: 2.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.red[700]!,
                                                  offset: Offset(3.0, 4.0),
                                                  blurRadius: 5.0,
                                                  spreadRadius: 2.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text('Login', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 20.0)),
                            ),

                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
