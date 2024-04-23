//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto_viewer/pages/login_view_screen.dart';
// import 'package:crypto_viewer/pages/otp_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../custome_component_style/box_decoration.dart';
// import '../global/global_settings.dart';
// import '../services/firebase_service.dart';
// class RegisterScreen extends StatefulWidget {
//   RegisterScreen({super.key});
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final DatabaseReference ref = FirebaseService().databaseRef.child('users');
//   GlobalKey<FormState> formkey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final monoController = TextEditingController();
//   final passController = TextEditingController();
//   bool _obscureText = true;
//
//
//   @override
//   void dispose() {
//     super.dispose();
//     nameController.dispose();
//     emailController.dispose();
//     monoController.dispose();
//     passController.dispose();
//   }
//
//   Future<void> verifyEmail(var data, BuildContext context)async{
//      Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) =>  OTPScreen(email: data["email"].toString(),)),
//     );
//
//
//   }
//
//   Future<bool?> registerUser(var data, BuildContext context) async {
//     if(GlobalSettngs.isEmailVerified){
//       try{
//         await AuthenticationHelper().signUp(
//             email: data["email"],
//             password: data["pass"]
//         ).then((result) {
//           if (result == null) {
//             FirebaseFirestore.instance.collection("/users").add({
//               "name": data["name"],
//               "email": data["email"],
//               "mono": data["mono"],
//               "isEmailVerified": GlobalSettngs.isEmailVerified,
//             }).then((_) {
//               print("-------------------user added successfully-----------------\n\n \n\n");
//               return true;
//             }).catchError((err) {
//               return false;
//             }, test: (error) {
//               //return error is int && error >= 400;
//               return false;
//             });
//           }
//         });
//
//       }catch(e){
//         return false;
//       }
//       setState(() {
//         GlobalSettngs.isEmailVerified = false;
//       });
//     }
//     else{
//       try {
//         await verifyEmail(data, context).then((value) async {
//         });
//         setState(() {
//
//         });
//       } catch (e) {
//         // Handle exceptions
//         return false;
//         print("-------------------Exception caught while adding user-----------------\n\n $e \n\n");
//       }
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[900],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Form(
//               key: formkey, // Assigning GlobalKey<FormState> to Form widget
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//
//                   const SizedBox(height: 150.0),
//                   Text("Registration", style: TextStyle(color: Colors.white, fontSize: 30.0),),
//                   const SizedBox(height: 20.0),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: TextFormField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Full name',
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         hintText: 'John doe',
//                         hintStyle: TextStyle(color: Colors.white),
//                       ),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                       ),
//
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: TextFormField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Email',
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         hintText: 'abc@gmail.com',
//                         hintStyle: TextStyle(color: Colors.white),
//                       ),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                       ),
//                       validator: MultiValidator([
//                         RequiredValidator(errorText: "* Required"),
//                         EmailValidator(errorText: "Enter valid email id"),
//                       ]),
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Text("before entering the mobile number make sure you have added your country code first.", style: TextStyle(
//                       color: Colors.white, fontStyle: FontStyle.italic,
//                     ),),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: TextFormField(
//                       controller: monoController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Mobile number',
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         hintText: '91*** **** ***',
//                         hintStyle: TextStyle(color: Colors.white),
//                       ),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                       ),
//
//                     ),
//                   ),
//
//                   const SizedBox(height: 20.0),
//
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: TextFormField(
//                       obscureText: _obscureText,
//                       controller: passController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Password',
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         hintText: '******',
//                         hintStyle: TextStyle(color: Colors.white),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscureText ? Icons.visibility : Icons.visibility_off,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscureText = !_obscureText; // Toggle password visibility
//                             });
//                           },
//                         ),
//                       ),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20.0,
//                       ),
//                       validator: MultiValidator([
//                         RequiredValidator(errorText: "* Required"),
//                         MinLengthValidator(
//                             6, errorText: "Password should be atleast 6 characters"),
//                         MaxLengthValidator(
//                             15, errorText: "Password should not be greater than 15 characters")
//                       ]),
//                     ),
//                   ),
//                   const SizedBox(height: 20.0),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: Container(
//                       width: double.infinity,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25.0),
//                         border: BoxDecoratinStyes.CustomeBorder,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue[800]!,
//                             offset: Offset(-4.0, -4.0),
//                             blurRadius: 5.0,
//                             spreadRadius: 2.0,
//                           ),
//                           BoxShadow(
//                             color: Colors.blue[800]!,
//                             offset: Offset(3.0, 4.0),
//                             blurRadius: 5.0,
//                             spreadRadius: 2.0,
//                           ),
//                         ],
//                       ),
//
//
//
//                       child: Container(
//                         height: 150,
//                         child:ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey[300],
//                             foregroundColor: Colors.grey[900],
//                           ),
//                           onPressed: () async {
//                             bool? isOk = false;
//                             if (formkey.currentState!.validate()) {
//                               final name = nameController.text;
//                               final email = emailController.text;
//                               final mono = monoController.text;
//                               final pass = passController.text;
//
//                               var map = {};
//                               map['name'] = name;
//                               map['email'] = email;
//                               map['mono'] = mono;
//                               map['pass'] = pass;
//
//                                //sending the data to the function for register the user
//
//                               if(await registerUser(map, context) == null){
//                                 return;
//                               }
//                               else{
//                                 isOk = await registerUser(map, context);
//                               }
//                               print("------------------------$isOk----------------------------------");
//                             }
//                             else{
//                               showDialog(
//                                 context: context,
//                                 builder: (ctx) => AlertDialog(
//                                   backgroundColor:Colors.orange[700],
//                                   title: const Text("Fail", style: TextStyle(color: Colors.white),),
//                                   content: const Text("please add proper details", style: TextStyle(color: Colors.white)),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(ctx).pop();
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.all(14),
//                                         child: const Text("okay"),
//                                         decoration: BoxDecoration(
//                                           color: Colors.orange[700]!,
//                                           borderRadius: BorderRadius.circular(25.0),
//                                           border: BoxDecoratinStyes.CustomeBorder,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.orange[200]!,
//                                               offset: Offset(-4.0, -4.0),
//                                               blurRadius: 5.0,
//                                               spreadRadius: 2.0,
//                                             ),
//                                             BoxShadow(
//                                               color: Colors.orange[500]!,
//                                               offset: Offset(3.0, 4.0),
//                                               blurRadius: 5.0,
//                                               spreadRadius: 2.0,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                             if(isOk!=null){
//                               if(isOk){
//                                 await showDialog(
//                                   context: context,
//                                   builder: (ctx) => AlertDialog(
//                                     backgroundColor:Colors.green[700],
//                                     title: const Text("Success", style: TextStyle(color: Colors.white)),
//                                     content: const Text("User registered successfully", style: TextStyle(color: Colors.white)),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(ctx).pop();
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(14),
//                                           child: const Text("okay"),
//                                           decoration: BoxDecoration(
//                                             color: Colors.green[400]!,
//                                             borderRadius: BorderRadius.circular(25.0),
//                                             border: BoxDecoratinStyes.CustomeBorder,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.green[200]!,
//                                                 offset: Offset(-4.0, -4.0),
//                                                 blurRadius: 5.0,
//                                                 spreadRadius: 2.0,
//                                               ),
//                                               BoxShadow(
//                                                 color: Colors.green[700]!,
//                                                 offset: Offset(3.0, 4.0),
//                                                 blurRadius: 5.0,
//                                                 spreadRadius: 2.0,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                                 Navigator.pushReplacement(context,
//                                     MaterialPageRoute(builder: (context) => LoginScreen()));
//                               }
//                               else{
//                                 showDialog(
//                                   context: context,
//                                   builder: (ctx) => AlertDialog(
//                                     backgroundColor:Colors.red[700],
//                                     title: const Text("Fail", style: TextStyle(color: Colors.white),),
//                                     content: const Text("please add proper details", style: TextStyle(color: Colors.white)),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(ctx).pop();
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(14),
//                                           child: const Text("okay"),
//                                           decoration: BoxDecoration(
//                                             color: Colors.red[700]!,
//                                             borderRadius: BorderRadius.circular(25.0),
//                                             border: BoxDecoratinStyes.CustomeBorder,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.red[200]!,
//                                                 offset: Offset(-4.0, -4.0),
//                                                 blurRadius: 5.0,
//                                                 spreadRadius: 2.0,
//                                               ),
//                                               BoxShadow(
//                                                 color: Colors.red[500]!,
//                                                 offset: Offset(3.0, 4.0),
//                                                 blurRadius: 5.0,
//                                                 spreadRadius: 2.0,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }
//                             }
//
//                           },
//                           child: Text('Submit'),
//                         ),
//
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global_settings.dart';
import '../services/firebase_service.dart';
import 'otp_screen.dart';
import 'login_view_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _monoController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _monoController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail(String email, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPScreen(email: email)),
    );
  }

  Future<bool> _registerUser(Map<String, dynamic> data, BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['pass'],
      );
      await _firestore.collection('/users').doc(userCredential.user!.uid).set({
        "name": data["name"],
        "email": data["email"],
        "mono": data["mono"],
        "isEmailVerified": GlobalSettngs.isEmailVerified,
      });
      return true;
    } catch (e) {
      // Handle exceptions
      print("Exception caught while adding user: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150.0),
                  Text("Registration", style: TextStyle(color: Colors.grey[900], fontSize: 30.0)),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full name',
                        labelStyle: TextStyle(color: Colors.grey[900]),
                        hintText: 'John doe',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                      ),
                      style: TextStyle(color: Colors.grey[900], fontSize: 20.0),
                      validator: RequiredValidator(errorText: "* Required"),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[900]),
                        hintText: 'abc@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                      ),
                      style: TextStyle(color: Colors.grey[900], fontSize: 20.0),
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
                      controller: _monoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile number',
                        labelStyle: TextStyle(color: Colors.grey[900]),
                        hintText: '91*** **** ***',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                      ),
                      style: TextStyle(color: Colors.grey[900], fontSize: 20.0),

                      validator: MultiValidator([
                      RequiredValidator(errorText: "* Required with country code"),
                      MinLengthValidator(12, errorText: "Mobile number should be 10 digit"),
                      MaxLengthValidator(12, errorText: "Mobile number should be 10 digit"),
                      ]),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: _passController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[900]),
                        hintText: '******',
                        hintStyle: TextStyle(color: Colors.grey[900]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey[900],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: Colors.grey[900], fontSize: 20.0),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "* Required"),
                        MinLengthValidator(6, errorText: "Password should be at least 6 characters"),
                        MaxLengthValidator(15, errorText: "Password should not be greater than 15 characters"),
                      ]),
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0))
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final name = _nameController.text;
                            final email = _emailController.text;
                            final mono = _monoController.text;
                            final pass = _passController.text;

                            var map = {
                              'name': name,
                              'email': email,
                              'mono': mono,
                              'pass': pass,
                            };

                            if (GlobalSettngs.isEmailVerified) {

                              bool success = await _registerUser(map, context);
                              if (success) {
                                await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Registration successfully completed, Now you can login!",
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                GlobalSettngs.isEmailVerified = false;
                              } else {
                                _showErrorDialog(context, "Registration failed. Please try again.");
                              }
                            } else {
                              _verifyEmail(email, context);
                            }
                          }
                        },
                        child: Text('Register', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 20.0),),
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.green[700],
        title: Text("Success", style: TextStyle(color: Colors.white)),
        content: Text("User registered successfully", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: EdgeInsets.all(14),
              child: Text("Okay"),
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
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.red[700],
        title: Text("Error", style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: EdgeInsets.all(14),
              child: Text("Okay"),
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
}
