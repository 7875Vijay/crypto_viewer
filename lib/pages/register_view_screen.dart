import 'package:crypto_viewer/pages/login_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../custome_component_style/box_decoration.dart';
import '../services/firebase_service.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final DatabaseReference ref = FirebaseService().databaseRef.child('users');
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  Future<bool> registerUser(var data) async{
    bool isOk = false;
    try{
      await AuthenticationHelper().signUp(email: data["email"], password: data["pass"]).then((result) {
        if (result == null) {
          Future<void> setData() async{ //if the user signed in the create the record of its details in firebase
            await ref.set({
              "name":data["name"],
              "email": data["email"],
              "pass": data["pass"]
            });
            print("-------------------Register Result-----------------\n\n ${result} \n\n");
            isOk = true;
          }
          isOk = true;
        } else {
          isOk = false;
          print("-------------------Register Result-----------------\n\n ${false} \n\n");

        }
      });


    }
    catch(e){
      print("-------------------Register Result-----------------\n\n ${e} \n\n");

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor:Colors.red[700],
          title: const Text("Fail", style: TextStyle(color: Colors.white),),
          content: const Text("User not registered, database error", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Text("okay"),
                decoration: BoxDecoration(
                  color: Colors.red[700]!,
                  borderRadius: BorderRadius.circular(25.0),
                  border: BoxDecoratinStyes.CustomeBorder,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red[400]!,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.red[500]!,
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
    return isOk;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
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

                  const SizedBox(height: 150.0),
                  Text("Registration", style: TextStyle(color: Colors.white, fontSize: 30.0),),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full name',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'John doe',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),

                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: 'abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "* Required"),
                        EmailValidator(errorText: "Enter valid email id"),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: passController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: '******',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
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
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: BoxDecoratinStyes.CustomeBorder,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[800]!,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: Colors.blue[800]!,
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
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[900],
                          ),
                          onPressed: () async {
                            var isOk = false;
                            if (formkey.currentState!.validate()) {
                              final name = nameController.text;
                              final email = emailController.text;
                              final pass = passController.text;

                              var map = {};
                              map['name'] = name;
                              map['email'] = email;
                              map['pass'] = pass;

                               //sending the data to the function for register the user
                              isOk = await registerUser(map);
                              print("------------------------$isOk----------------------------------");
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:Colors.orange[700],
                                  title: const Text("Fail", style: TextStyle(color: Colors.white),),
                                  content: const Text("please add proper details", style: TextStyle(color: Colors.white)),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("okay"),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[700]!,
                                          borderRadius: BorderRadius.circular(25.0),
                                          border: BoxDecoratinStyes.CustomeBorder,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange[200]!,
                                              offset: Offset(-4.0, -4.0),
                                              blurRadius: 5.0,
                                              spreadRadius: 2.0,
                                            ),
                                            BoxShadow(
                                              color: Colors.orange[500]!,
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
                            if(isOk){
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:Colors.green[700],
                                  title: const Text("Success", style: TextStyle(color: Colors.white)),
                                  content: const Text("User registered successfully", style: TextStyle(color: Colors.white)),
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:Colors.red[700],
                                  title: const Text("Fail", style: TextStyle(color: Colors.white),),
                                  content: const Text("please add proper details", style: TextStyle(color: Colors.white)),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("okay"),
                                        decoration: BoxDecoration(
                                          color: Colors.red[700]!,
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
                                              color: Colors.red[500]!,
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
                          child: Text('Submit'),
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
