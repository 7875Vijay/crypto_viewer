import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:crypto_viewer/pages/register_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../global/global_settings.dart';
class OTPScreen extends StatefulWidget {
  final email;
  const OTPScreen({required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  //controllers:
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();
  var fourthController = TextEditingController();
  var firstFocusNode = FocusNode();
  var secondFocusNode = FocusNode();
  var thirdFocusNode = FocusNode();
  var fourthdFocusNode = FocusNode();

  String warningText = "";
  String generatedotp = "";
  Future<void> verifyEmail(var emailtoverify) async {
    try {
      var random = Random();
      int randomNumber = 1001 + random.nextInt(9999 - 1001 + 1);
      generatedotp = randomNumber.toString();

      String username = 'vp0013622@gmail.com';
      String password = 'ourj egwz gboo iyzl';

      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username, 'CryptoView')
        ..recipients.add(emailtoverify.toString())
        ..ccRecipients.addAll([])
        ..subject = 'Login Email ID Verification'
        ..text =
            'Hey there,\nYour One Time Password (OTP) for login: ${randomNumber}\nPlease note that do not share this OTP with anyone\n\nRegards,\nCrypto view app\ndeveloper0013621@gmail.com'
        ..html = '''
        <p>Hey there,</p>
        <p>Your One Time Password (OTP) for email verification is: ${randomNumber}</p>
        <p>Please note that do not share this OTP with anyone</p>
        <p>Regards,<br>Crypto view app<br>developer0013621@gmail.com</p>
      ''';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent. Error: $e');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      } catch (e) {
        print('Unexpected error: $e');
      }

    } catch (e) {
      print("==============================Error while verifyEmail=> $e============================");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    verifyEmail(widget.email);
    firstFocusNode.requestFocus();
  }

  @override
  void dispose() {
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthdFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List <String> slitedEmail = widget.email.split("@");
    String firstpartofemail = "";
    for(int i = 0; i< slitedEmail[0].length; i++){
      firstpartofemail += "*";
    }



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.grey[900],
            size: 25.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Verification code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.grey[900],),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("We have send the OTP for email verification", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0, color: Colors.grey[400]),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(children: [
                    Text("to ",style: TextStyle(color: Colors.grey[400], fontSize: 18.0)),
                    Text("${firstpartofemail}${slitedEmail[1]}", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 15.0)),

                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Change Email ID?", style: TextStyle(color: Colors.blue[900], fontSize: 15.0))
                  ),
                ),

                SizedBox(height: 10.0,),

                Padding(
                  padding: const EdgeInsets.only(left:20.0,right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: TextFormField(
                            autofocus: true,
                            controller: firstController,
                            focusNode: firstFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900], fontSize: 25.0),
                            inputFormatters: [LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              secondFocusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: TextFormField(
                            autofocus: true,
                            controller: secondController,
                            focusNode: secondFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900], fontSize: 25.0),
                            inputFormatters: [LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              thirdFocusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: TextFormField(
                            autofocus: true,
                            controller: thirdController,
                            focusNode: thirdFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900], fontSize: 25.0),
                            inputFormatters: [LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              fourthdFocusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 68,
                        width: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: BoxDecoratinStyes.CustomeBorder,
                          boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: TextFormField(
                            autofocus: true,
                            controller: fourthController,
                            focusNode: fourthdFocusNode,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900], fontSize: 25.0),
                            inputFormatters: [LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Text("${warningText}",style: TextStyle(fontSize: 14.0, color: Colors.red[900], fontStyle: FontStyle.italic),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        warningText = "The new OTP has been emailed to you gain";
                        verifyEmail(widget.email);
                        firstFocusNode.requestFocus();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                      shadowColor: Color.fromARGB(255, 192, 191, 191),
                    ),
                    child:Text("Resend",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                      ),
                    ),
                ),
                SizedBox(width: 20.0,),
                ElevatedButton(
                  onPressed: ()async{
                    String firstnumber = firstController.text;
                    String secondnumber = secondController.text;
                    String thirdnumber = thirdController.text;
                    String fourthnumber = fourthController.text;

                    String finalNumber = firstnumber+secondnumber+thirdnumber+fourthnumber;
                    if(generatedotp == finalNumber){
                      GlobalSettngs.isEmailVerified = true;
                      await CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Your email is verified",
                      );
                      Navigator.pop(context);
                    }
                    else{
                      setState(() {
                        warningText = "Wrong OTP";
                      });
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                    shadowColor: Color.fromARGB(255, 192, 191, 191),
                  ),
                  child:Text("Confirm",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
