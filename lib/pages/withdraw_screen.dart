// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:crypto_viewer/curd_methods/crypto_wallet_firebase_operations.dart';
// import 'package:crypto_viewer/pages/add_bank_account_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// import '../services/firebase_service.dart';
//
// class WithDrawScreen extends StatefulWidget {
//   var walletData;
//   var walletType;
//   WithDrawScreen(this.walletData, this.walletType);
//
//   @override
//   State<WithDrawScreen> createState() => _WithDrawScreenState();
// }
//
// class _WithDrawScreenState extends State<WithDrawScreen> {
//   double ammountToWithdraw = 0.0;
//   TextEditingController ammountToWithdrawController = TextEditingController();
//   late List<bool> isBankSelectionCheckboxChecked;
//   var myList = [];
//
//   Future<void>getData() async{
//     try{
//       var collection = FirebaseFirestore.instance.collection("add_account");
//       var querySnapshot = await collection.get();
//
//       List<Map<String, dynamic> > datalist = [];
//
//       for (var queryDocumentSnapshot in querySnapshot.docs) {
//         datalist.add(queryDocumentSnapshot.data());
//       }
//       setState(() {
//         myList = datalist;
//       });
//     }
//     catch(e){
//
//     }
//   }
//
//   Future<void>getAllPresentBankAccountsList()async{
//     await getData();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getAllPresentBankAccountsList();
//     isBankSelectionCheckboxChecked = List.generate(myList.length, (index) => false);
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     ammountToWithdrawController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mq = MediaQuery.of(context).size;
//     return  Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.0,
//         leading: IconButton(
//           icon: Icon(
//             CupertinoIcons.back,
//             color: Colors.grey[900],
//             size: 25.0,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           "Withdraw Money",
//           style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           TextButton(onPressed: () {}, child: Text("Cancel", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 15.0))),
//         ],
//       ),
//       body: myList.length!=0 && widget.walletData != null && widget.walletType!=null && widget.walletType!=""? SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
//           children: [
//             SizedBox(height: 70.0),
//             Center(child: Text("Amount", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500, fontSize: 15.0))),
//             Center(
//               child: Expanded(
//                 child: TextFormField(
//                     controller: ammountToWithdrawController,
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: '\$0.0',
//                       hintStyle: TextStyle(
//                         color: Colors.grey[900],
//                         fontWeight: FontWeight.w700,
//                         fontSize: 65.0,
//                       ),
//                     ),
//                     style: TextStyle(
//                       color: Colors.grey[900],
//                       fontWeight: FontWeight.w700,
//                       fontSize: 65.0,
//                     ),
//                     onChanged: (value)async{
//                       if (value == null || value.isEmpty) {
//                         await CoolAlert.show(
//                           context: context,
//                           type: CoolAlertType.error,
//                           text: "Enter the valid amount",
//                         );
//                         setState(() {
//                           ammountToWithdrawController.clear();
//                         });
//                         return null;
//                       }
//                       double? parsedValue = double.tryParse(value.toString());
//                       if (parsedValue == null || parsedValue <= 0) {
//                         await CoolAlert.show(
//                           context: context,
//                           type: CoolAlertType.error,
//                           text: "Enter the valid amount",
//                         );
//                         setState(() {
//                           ammountToWithdrawController.clear();
//                         });
//                         return null;
//                       }
//                     },
//                   ),
//               ),
//             ),
//             SizedBox(height: 40.0),
//             Center(child: Text("\$${double.parse(widget.walletData["amount"].toString()).toStringAsFixed(3)}", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w400, fontSize: 25.0))),
//             Center(child: Text("AVAILABLE BALANCE", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500, fontSize: 15.0))),
//             SizedBox(height: 70.0),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: SizedBox(
//                 width: mq.width * 1,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Icon(
//                             CupertinoIcons.creditcard,
//                             size: 20,
//                           ), //Icons.move_down
//                           SizedBox(width: 5.0),
//                           Text(
//                             "Withdraw Money To",
//                             style: TextStyle(fontWeight: FontWeight.w700),
//                           ),
//                           ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               elevation: 0.0,
//                               backgroundColor: Colors.blue[50],
//                               minimumSize: Size(mq.width * 0.2, 30),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
//                             ),
//                             onPressed: ()async {
//                               if(await AuthenticationHelper().isAuthenticated(context)){
//                                 Navigator.push(
//                                   context,
//                                   await MaterialPageRoute(
//                                       builder: (context) => AddNewBankAccountScreen()),
//                                 );
//                               }
//                             },
//                             icon: Icon(
//                               CupertinoIcons.add,
//                               size: 20,
//                             ),
//                             label: Text("Add Beneficiary"),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(5.0),
//                       child: Container(
//                         height: mq.height * 0.25,
//                         child: myList.length != 0
//                             ? ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: myList.length,
//                           itemBuilder: (context, index) {
//                             // Ensure isBankSelectionCheckboxChecked has the same length as myList
//                             if (isBankSelectionCheckboxChecked.length <= index) {
//                               // If the index is out of bounds, add more elements
//                               isBankSelectionCheckboxChecked.addAll(
//                                   List<bool>.filled(myList.length - isBankSelectionCheckboxChecked.length, false));
//                             }
//                             return ListTile(
//                               shape: isBankSelectionCheckboxChecked[index]
//                                   ? RoundedRectangleBorder(
//                                 side: BorderSide(color: Colors.blue, width: 2),
//                                 borderRadius: BorderRadius.circular(5),
//                               )
//                                   : RoundedRectangleBorder(
//                                 side: BorderSide(color: Colors.transparent, width: 0),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundColor: Colors.blue[50],
//                                 child: Image.asset(
//                                   "assets/images/bank.png",
//                                   height: 20.0,
//                                   width: 20.0,
//                                 ),
//                               ),
//                               title: Text(myList[index]["bankname"].toString()!,
//                                   style: TextStyle(fontWeight: FontWeight.w700)),
//                               subtitle: Text(myList[index]["accountno"].toString()!,
//                                   style: TextStyle(
//                                       color: Colors.grey[400], fontWeight: FontWeight.w700)),
//                               trailing: Checkbox(
//                                 checkColor: Colors.white,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     for (int i = 0; i < isBankSelectionCheckboxChecked.length; i++) {
//                                       isBankSelectionCheckboxChecked[i] = (i == index) ? true : false;
//                                     }
//                                   });
//                                 },
//                                 value: isBankSelectionCheckboxChecked[index],
//                               ),
//                             );
//                           },
//                         )
//                             : Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               CupertinoActivityIndicator(
//                                 color: Colors.blue[900],
//                                 animating: true,
//                                 radius: 20,
//                               ),
//                               SizedBox(
//                                 height: 10.0,
//                               ),
//                               Text(
//                                 "Bank accounts not found for withdraw",
//                                 style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontStyle: FontStyle.italic,
//                                     fontSize: 17.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: EdgeInsets.all(5.0),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[900],
//                           elevation: 0.0,
//                           minimumSize: Size(mq.width * 0.95, 50),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//                         ),
//                         onPressed: () async {
//                             if(ammountToWithdrawController.text=="" || ammountToWithdrawController.text==null){
//                               CoolAlert.show(
//                                 context: context,
//                                 type: CoolAlertType.error,
//                                 text: "Invalid amount",
//                               );
//                               return;
//                             }
//                             print("-----------------said not------------------");
//                             var user = AuthenticationHelper().user;
//                             var uid = user.uid;
//                             var amounttowithdraw = double.parse(ammountToWithdrawController.text.toString());
//                             var walletamount = double.parse(widget.walletData["amount"].toString());
//                             if( amounttowithdraw > walletamount){
//                               await CoolAlert.show(
//                                 context: context,
//                                 type: CoolAlertType.error,
//                                 text: "Insufficient wallet amount found",
//                               );
//                               ammountToWithdrawController.clear();
//                               return;
//                             }
//
//                             if(!isBankSelectionCheckboxChecked.contains(true)){
//                               await CoolAlert.show(
//                                 context: context,
//                                 type: CoolAlertType.error,
//                                 text: "Select bank account first",
//
//                               );
//                               return;
//                             }
//
//                             var transactionRemainingAmount =  double.parse(widget.walletData["amount"].toString()) - double.parse(ammountToWithdrawController.text.toString());
//                             await CryptoWalletFirebaseOperation.updateWalletAmount(uid, widget.walletType, DateTime.now(), transactionRemainingAmount, context);
//
//                         },
//                         child: Text("Confirm Withdraw", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20.0)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ) : Center(
//         child: CupertinoActivityIndicator(
//           color: Colors.blue[900],
//           animating: true,
//           radius: 20,
//         ),
//       )
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/curd_methods/crypto_wallet_firebase_operations.dart';
import 'package:crypto_viewer/pages/add_bank_account_screen.dart';
import '../services/firebase_service.dart';

class WithDrawScreen extends StatefulWidget {
  final dynamic walletData;
  final dynamic walletType;

  const WithDrawScreen(this.walletData, this.walletType);

  @override
  State<WithDrawScreen> createState() => _WithDrawScreenState();
}

class _WithDrawScreenState extends State<WithDrawScreen> {
  late TextEditingController ammountToWithdrawController;
  late List<Map<String, dynamic>> myList;
  late int selectedBankIndex;
  late bool loading;

  @override
  void initState() {
    super.initState();
    ammountToWithdrawController = TextEditingController();
    myList = [];
    selectedBankIndex = -1;
    loading = true;
    getData();
  }

  @override
  void dispose() {
    ammountToWithdrawController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      var collection = FirebaseFirestore.instance.collection("add_account");
      var querySnapshot = await collection.get();

      setState(() {
        myList = querySnapshot.docs.map((doc) => doc.data()).toList();
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Error: $e");
    }
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
          "Withdraw Money",
          style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 15.0),
            ),
          ),
        ],
      ),
      body: loading
          ? Center(
        child: CupertinoActivityIndicator(
          color: Colors.blue[900],
          animating: true,
          radius: 20,
        ),
      )
          : myList.isNotEmpty && widget.walletData != null && widget.walletType != null && widget.walletType != ""
          ? SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70.0),
            Center(
                child: Text(
                  "Amount",
                  style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500, fontSize: 15.0),
                )),
            Center(
              child: TextFormField(
                controller: ammountToWithdrawController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '\$0.0',
                  hintStyle: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w700,
                    fontSize: 65.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w700,
                  fontSize: 65.0,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Center(
                child: Text(
                  "\$${double.parse(widget.walletData["amount"].toString()).toStringAsFixed(3)}",
                  style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w400, fontSize: 25.0),
                )),
            Center(
                child: Text(
                  "AVAILABLE BALANCE",
                  style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500, fontSize: 15.0),
                )),
            SizedBox(height: 70.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: mq.width * 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            CupertinoIcons.creditcard,
                            size: 20,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "Withdraw Money To",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: Colors.blue[50],
                              minimumSize: Size(mq.width * 0.2, 30),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                            ),
                            onPressed: () async {
                              if (await AuthenticationHelper().isAuthenticated(context)) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddNewBankAccountScreen()),
                                );
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.add,
                              size: 20,
                            ),
                            label: Text("Add Beneficiary"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        height: mq.height * 0.25,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: index == selectedBankIndex ? Colors.blue[50] : null,
                              onTap: () {
                                setState(() {
                                  selectedBankIndex = index;
                                });
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[50],
                                child: Image.asset(
                                  "assets/images/bank.png",
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ),
                              title: Text(
                                myList[index]["bankname"].toString()!,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                myList[index]["accountno"].toString()!,
                                style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w700),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          elevation: 0.0,
                          minimumSize: Size(mq.width * 0.95, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: selectedBankIndex == -1
                            ? null
                            : () async {
                          double amountToWithdraw = double.parse(ammountToWithdrawController.text);
                          double walletAmount = double.parse(widget.walletData["amount"].toString());

                          if (amountToWithdraw > walletAmount) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "Insufficient wallet amount found",
                            );
                            return;
                          }

                          var bankInfo = myList[selectedBankIndex];
                          var transactionRemainingAmount = walletAmount - amountToWithdraw;

                          await CryptoWalletFirebaseOperation.updateWalletAmount(
                            AuthenticationHelper().user.uid,
                            widget.walletType,
                            DateTime.now(),
                            transactionRemainingAmount,
                            context,
                          );

                          // Additional logic to handle withdrawal to bank
                        },
                        child: Text("Confirm Withdraw", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Text(
          "Bank accounts not found for withdrawal",
          style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic, fontSize: 17.0),
        ),
      ),
    );
  }
}
