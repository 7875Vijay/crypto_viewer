import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../custome_component_style/box_decoration.dart';
class AddNewBankAccountScreen extends StatefulWidget {
  const AddNewBankAccountScreen({super.key});

  @override
  State<AddNewBankAccountScreen> createState() => _AddNewBankAccountScreenState();
}

class _AddNewBankAccountScreenState extends State<AddNewBankAccountScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController nameAsPerAccountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController IFSCCodeController = TextEditingController();

  //methods:
  Future<bool>addBankAccountIfNotPresent(var data)async{
    bool isOk = false;
    if(await isBankAccountFound(data)){
      bankNameController.clear();
      nameAsPerAccountController.clear();
      accountNoController.clear();
      IFSCCodeController.clear();
      Navigator.pop(context);
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "You have already added this bank account",
      );
      isOk = false;
    }
    else{
      var user = AuthenticationHelper().user;
      var uid = user.uid;
      FirebaseFirestore.instance.collection("/add_account").add({
        "nameasperbankaccount":data["nameasperbankaccount"],
        "bankname":data["bankname"],
        "accountno": data["accountno"],
        "ifsccode": data["ifsccode"],
        "date_time": DateTime.now().toString(),
        "created_by_uid":uid.toString(),
      }).catchError((err) {
        print('------------------------------------Error: $err---------------------------------'); // Prints 401.
      }, test: (error) {
        return error is int && error >= 400;
      });
      isOk = true;
    }
    return isOk;
  }
  Future<bool>isBankAccountFound(var datarecieved)async{
    bool isOk = false;
    try{
      var collection = FirebaseFirestore.instance.collection("add_account");
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        var user = AuthenticationHelper().user;
        var uid = user.uid;
        if(data["accountno"]!=null && data['created_by_uid'] == uid){
          if(data["bankname"]==datarecieved["bankname"] && data["accountno"]==datarecieved["accountno"] && data["ifsccode"]==datarecieved["ifsccode"]){
            isOk = true;
            break;
          }
        }
        else{
          isOk = false;
        }
      }
    }
    catch(e){
      isOk = false;
    }
    return isOk;
  }


  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
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
        title: Text(
          "Add Bank Account",
          style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(onPressed: () {}, child: Text("Cancel", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 15.0))),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: mq.height * 0.3,
              width: mq.width * 0.3,
                child: Image.asset("assets/images/bank.png",)),
            Form(
                key: formkey,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("Enter the bank details properly", style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),),),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: nameAsPerAccountController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name as per bank account',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'John doe',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20.0,
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                        ]),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        // obscureText: _obscureText,
                        controller: bankNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bank name',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'HDFC bank',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          // suffixIcon: IconButton(
                          //   icon: Icon(
                          //     _obscureText ? Icons.visibility : Icons.visibility_off,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       _obscureText = !_obscureText; // Toggle password visibility
                          //     });
                          //   },
                          // ),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20.0,
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          // MinLengthValidator(
                          //     6, errorText: "Password should be atleast 6 characters"),
                          // MaxLengthValidator(
                          //     15, errorText: "Password should not be greater than 15 characters")
                        ]),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: accountNoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Account number',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: '**** **** 5963',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20.0,
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                        ]),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: IFSCCodeController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'IFSC code',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'HDFC****',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 20.0,
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                        ]),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          minimumSize: Size(mq.width * 0.9, 50),
                        ),
                        onPressed: () async {
                          bool isOk = false;
                          if (formkey.currentState!.validate()) {
                            final nameasperbankaccount = nameAsPerAccountController.text;
                            final bankname = bankNameController.text;
                            final accountno = accountNoController.text;
                            final ifsccode = IFSCCodeController.text;

                            var map = {};
                            map['nameasperbankaccount'] = nameasperbankaccount;
                            map['bankname'] = bankname;
                            map['accountno'] = accountno;
                            map['ifsccode'] = ifsccode;
                            isOk = await addBankAccountIfNotPresent(map);
                            print("-----------------------$isOk----------------------");
                            // do something with the form data
                          }
                          if(isOk){
                            await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: "Bank account added successfully",
                            );
                             Navigator.pop(context);
                          }
                          else{
                            await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "Bank account not added",
                            );
                            bankNameController.clear();
                            nameAsPerAccountController.clear();
                            accountNoController.clear();
                            IFSCCodeController.clear();
                          }
                        },
                        child: Text('Add Bank Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),),
                      )
                    ),
                  ],
                ),),
          ],
        ),
      ),
    );
  }
}
