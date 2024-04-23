
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/curd_methods/crypto_wallet_firebase_operations.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'mywallet_view_screen.dart';

class MonthYearInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (text.length == 2) {
      return newValue.copyWith(
        text: '$text/',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  var cardData;
  String walletType;
  PaymentScreen(this.cardData, this.walletType);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var fullNameController = TextEditingController();
  var carNumberController = TextEditingController();
  var validUpToController = TextEditingController();
  var cvvController = TextEditingController();
  var amoutController = TextEditingController();
  final _inputFormatter = MonthYearInputFormatter();

  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode cardNumberFocusNode = FocusNode();
  final FocusNode validUpToFocusNode = FocusNode();
  final FocusNode cvvFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();


  @override
  void dispose() {
    super.dispose();
    fullNameFocusNode.dispose();
    cardNumberFocusNode.dispose();
    validUpToFocusNode.dispose();
    cvvFocusNode.dispose();
    amountFocusNode.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var walletetype = widget.walletType;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle:true,
        backgroundColor: Colors.grey[300],
        elevation:0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.grey[900], size: 25.0,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: const Text(
            "Payment",
            textAlign: TextAlign.center,
          ),

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Container(
              width: 330.0,
              height: 200.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 192, 191, 191),
                      offset: const Offset(
                        4.0,
                        4.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 255, 255),
                      offset: const Offset(-4, -4),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                  ],
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/chip.png',
                          height: 50,
                          width: 60,
                        ),
                        const SizedBox(
                          width: 140.0,
                        ),
                        SvgPicture.asset(
                          'assets/svgs/visa.svg',
                          width: 80,
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.cardData["cardno"]!=null && widget.cardData["cardno"]!="" ?widget.cardData["cardno"]:"xxxx xxxx 3536",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80.0,
                      ),
                      Column(
                        children: [
                          Text("Valid",
                              style: TextStyle(
                                fontSize: 10.0,
                              )),
                          Text("For",
                              style: TextStyle(
                                fontSize: 10.0,
                              )),
                        ],
                      ),
                      Text(widget.cardData["validupto"]!=null && widget.cardData["validupto"]!="" ?widget.cardData["validupto"]:"04/28",
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.cardData["fullname"]!=null && widget.cardData["fullname"]!="" ?widget.cardData["fullname"]:"Joh Doe",
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                      const SizedBox(
                        width: 80.0,
                      ),
                      Image.asset(
                        'assets/images/mastercard.png',
                        width: 50,
                        height: 60,
                      ),
                    ],
                  ),
                ],
              ),
            ), //visa car view

            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, -10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color.fromARGB(255, 255, 255, 255),
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color(0xFFD5D1D1),
                            inset: true,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: fullNameController,
                        focusNode: fullNameFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          // border: OutlineInputBorder(),
                          border: InputBorder.none,
                          labelText: 'FULL NAME',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'John doe',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, -10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color.fromARGB(255, 255, 255, 255),
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color(0xFFD5D1D1),
                            inset: true,
                          ),

                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: carNumberController,
                        focusNode: cardNumberFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // border: OutlineInputBorder(),
                          labelText: 'CARD NUMBER',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: '**** **** 1234',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, -10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color.fromARGB(255, 255, 255, 255),
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color(0xFFD5D1D1),
                            inset: true,
                          ),

                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: validUpToController,
                        focusNode: validUpToFocusNode,
                        inputFormatters: [_inputFormatter],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'VALID FOR',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'mm/yy',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, -10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color.fromARGB(255, 255, 255, 255),
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color(0xFFD5D1D1),
                            inset: true,
                          ),

                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: cvvController,
                        focusNode: cvvFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // border: OutlineInputBorder(),
                          labelText: 'CVV',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: '6369',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, -10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color.fromARGB(255, 255, 255, 255),
                            inset: true,
                          ),
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Color(0xFFD5D1D1),
                            inset: true,
                          ),

                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: amoutController,
                        focusNode: amountFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // border: OutlineInputBorder(),
                          labelText: 'AMOUNT IN \$',
                          labelStyle: TextStyle(
                            color: Colors.grey[900],
                          ),
                          hintText: 'Amount in dollar (\$)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: const Offset(
                              4.0,
                              4.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Color.fromARGB(255, 255, 255, 255),
                            offset: const Offset(-4, -4),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: 50.0,
                        child: TextButton(
                          onPressed: () async {
                            if (fullNameController == null) {
                              fullNameController.text == "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "Full name required!",
                              );
                              fullNameFocusNode.requestFocus();
                              setState(() {});
                              return;
                            }
                            if (carNumberController.text.length <= 11) {
                              carNumberController.text == "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "Card number not valid!",
                              );
                              cardNumberFocusNode.requestFocus();
                              setState(() {});
                              return;
                            }
                            if (validUpToController == null ||
                                validUpToController.text.length <= 4 ||
                                validUpToController.text.length >= 6) {
                              // Get today's date
                              DateTime today = DateTime.now();

                              // Parse the input month and date
                              List<String> parts =
                                  validUpToController.text.split('/');
                              int inputMonth = int.parse(parts[0]);
                              int inputDay = int.parse(parts[1]);

                              // Construct a DateTime object for the input month and date
                              DateTime inputDate =
                                  DateTime(today.year, inputMonth, inputDay);

                              // Check if the input date is greater than or equal to today's date
                              if (inputDate.isAfter(today) ||
                                  inputDate.isAtSameMomentAs(today)) {
                                print(
                                    "$validUpToController.text is greater than or equal to today's date.");
                              } else {
                                validUpToController.text == "";
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: "Expiry date not valid!",
                                );
                                validUpToFocusNode.requestFocus();
                                setState(() {});
                                return;
                              }

                              validUpToController.text == "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "Expiry date not valid!",
                              );
                              validUpToFocusNode.requestFocus();
                              setState(() {});
                            }
                            if (cvvController == null ||
                                cvvController.text.length <= 2 ||
                                cvvController.text.length >= 5) {
                              cvvController.text == "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "Cvv number not valid!",
                              );
                              cvvFocusNode.requestFocus();
                              setState(() {});
                              return;
                            }

                            if (amoutController == null ||
                                amoutController.text.length <= 0) {
                              amoutController.text == "";
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "Amount must be greater than 0",
                              );
                              amountFocusNode.requestFocus();
                              setState(() {});
                              return;
                            }

                            var data = {};
                            data['fullname'] = fullNameController.text;
                            data['cardno'] = carNumberController.text;
                            data['validupto'] = validUpToController.text;
                            data['cvv'] = cvvController.text;
                            data['amount'] = amoutController.text;
                            if (await CryptoWalletFirebaseOperation.addAmountToTheWallet(data, context, walletetype )) {
                                                      //Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                await MaterialPageRoute(builder: (context) => MyWalletScreen()),
                              );
                            } else {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                text: "something went wrong, amount not added to wallet!",
                              );
                              fullNameController.text = "";
                              carNumberController.text = "";
                              validUpToController.text = "";
                              cvvController.text = "";
                              amoutController.text = "";
                              fullNameFocusNode.requestFocus();
                              setState(() {});
                            }
                          },
                          child: Center(
                            child: Text(
                              "Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
