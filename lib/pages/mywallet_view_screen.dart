import 'dart:convert';
import 'package:crypto_viewer/curd_methods/crypto_wallet_firebase_operations.dart';
import 'package:crypto_viewer/global/global_settings.dart';
import 'package:crypto_viewer/pages/payment_screen.dart';
import 'package:crypto_viewer/pages/transaction_view_screen.dart';
import 'package:crypto_viewer/pages/withdraw_screen.dart';
import 'package:crypto_viewer/services/firebase_service.dart';
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:cryptocoins_icons/cryptocoins_icons.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../custome_component_style/alert.dart';
import '../custome_component_style/ctm_drawer.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

import '../custome_component_style/custome_charts.dart';
import 'crypto_view_sreen.dart';

class CryptoData {
  final String? id;
  final String? rank;
  final String? symbol;
  final String? name;
  final String? supply;
  final String? maxSupply;
  final String? marketCapUsd;
  final String? volumeUsd24Hr;
  final String? priceUsd;
  final String? changePercent24Hr;
  final String? vwap24Hr;

  CryptoData({
    this.id,
    this.rank,
    this.symbol,
    this.name,
    this.supply,
    this.maxSupply,
    this.marketCapUsd,
    this.volumeUsd24Hr,
    this.priceUsd,
    this.changePercent24Hr,
    this.vwap24Hr,
  });
}
class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  bool needToShowTransferAndWithdrawButtons = false;
  String historyTitle = "Crypto";
  late double _screenWidth;
  late double _screenHeight;
  String walletType = GlobalSettngs.cryptowalletname;
  var WalletDataIfFound = {};
  var myCoinsList = [];
  var myStocksList = [];
  var _isCoinInProfit = false;
  var _cryptoPrice = 0.0;
  
  var myCryptoListToPopulate = [];
  var myCryptoListCount = 0;

  //this funtion change the content of the ui dynamically of the wallet page
  Future<void> setupState(var collectionname) async {
    final user = AuthenticationHelper().user;
    final uid = user.uid;
    var iswalleteavailable = await CryptoWalletFirebaseOperation.isWalletFound(uid,collectionname );
    print("---- $walletType is found : $iswalleteavailable ");
    if(iswalleteavailable){
      try{
        List<Map<String, dynamic> > listOfWallets = await CryptoWalletFirebaseOperation.getCryptoWalletDataFromFirebaseCollection(collectionname);
        if(listOfWallets!=null){
          WalletDataIfFound = listOfWallets[0];
          needToShowTransferAndWithdrawButtons = true;

        }

      }
      catch (e){
        needToShowTransferAndWithdrawButtons = false;
        CutomeAlert.showErrorAlert(context, "Something went wrong with fetching wallet data");
      }
    }
    else{
      WalletDataIfFound = {};
      needToShowTransferAndWithdrawButtons = false;
      WalletDataIfFound["cardno"] = "xxxx xxxx 3536";
      WalletDataIfFound["validupto"] = "04/28";
      WalletDataIfFound["fullname"] = "Joh Doe";
    }
    setState(() {});
  }

  Future<void>getMyCoins(var collectionname)async{
    myCoinsList = await CryptoWalletFirebaseOperation.getMyCoinsDataFromFirebaseCollection(collectionname);
    myCryptoListCount = myCoinsList.length;
    for(var i in myCoinsList){
      String currentprice = await currentpriceofmycoin(double.parse(i["quantity"].toString()), i["id"].toString());
      String percentagePandL = await percentageOfProfitandLoss(currentprice,i["totalamountpaid"].toString());
      bool isloss = await checkIsLoss(currentprice, i["totalamountpaid"].toString());
      String mprice = await getMarketPrice(i["id"].toString());
      String mpricepercent = await getMarketPricePercent(i["id"].toString());
      var map = {};
      map["id"] = i["id"];
      map["symbol"] = i["symbol"];
      map["name"] = i["name"];
      map["quantity"] = i["quantity"]??"";
      map["currentprice"] = currentprice??"";
      map["totalamountpaid"] = i["totalamountpaid"]??"";
      map["percentageofprofitandloss"] = percentagePandL??"";
      map["isloss"] = isloss;
      map["marketprice"] = mprice;
      map["marketpricepercentage"] = mpricepercent;
      myCryptoListToPopulate.add(map);

    }

    setState(() {

    });
  }
Future<String>getMarketPrice(String id)async{
    String price = "";
    String url = "https://api.coincap.io/v2/assets/$id";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData['data']["priceUsd"].toString();
      } else {
        return "0";
        print("Failed to get crypto price: ${response.statusCode}");
      }
    } catch (e) {
      return "0";
      print("Error fetching crypto price: $e");
    }
}
Future<String>getMarketPricePercent(String id)async{
    String price = "";
    String url = "https://api.coincap.io/v2/assets/$id";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return responseData['data']["changePercent24Hr"].toString();
      } else {
        return "0";
        print("Failed to get crypto price: ${response.statusCode}");
      }
    } catch (e) {
      return "0";
      print("Error fetching crypto price: $e");
    }
}

  Future<bool>checkIsLoss(String currentprice, String totalamountpaid)async{
    bool isOk = false;
    double currp = double.parse(currentprice);
    double paid = double.parse(totalamountpaid);
    if((currp-paid) > 0 ){
      isOk = true;
    }
    else{
      isOk = false;
    }
    return isOk;
  }

  Future<String>currentpriceofmycoin(double quantity, String id)async{
    String url = "https://api.coincap.io/v2/assets/$id";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        double currpriceusd =  quantity * double.parse(responseData['data']["priceUsd"].toString());
        return currpriceusd.toString();
      } else {
        return "0";
        print("Failed to get crypto price: ${response.statusCode}");
      }
    } catch (e) {
      return "0";
      print("Error fetching crypto price: $e");
    }
  }
  Future<String>percentageOfProfitandLoss(String currentprice, String totalamountpaid )async{
    double currp = double.parse(currentprice);
    double paid = double.parse(totalamountpaid);
    double percentage = ((currp - paid)/paid)*100;
    return percentage.toStringAsFixed(2);
  }


  @override
  void initState(){
    super.initState();
     setupState(walletType);
     getMyCoins("mycoins");

    //await AuthenticationHelper().isAuthenticated(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Accessing size after the first frame is drawn

      _screenWidth = MediaQuery.of(context).size.width;
      _screenHeight = MediaQuery.of(context).size.height;
      // Rebuild the widget after getting the size
    });

    historyTitle = "Crypto";
  }

  // var _paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '99.99',
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];
  // void onApplePayResult(paymentResult) {
  //   // Send the resulting Apple Pay token to your server / PSP
  // }
  //
  // void onGooglePayResult(paymentResult) {
  //   // Send the resulting Google Pay token to your server / PSP
  // }

  String formatedNumberString(String number){
    double num = double.parse(number);
    return num.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
    if(WalletDataIfFound == null){
      return Center(
        child: CupertinoActivityIndicator(
          color: Colors.blue[900],
          animating: true,
          radius: 20,
        ),
      );
          //child: CircularProgressIndicator());
    }
    else {
      return Scaffold(
        key: _scaffoldState,
        backgroundColor: Colors.blue[900],
        body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 300.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                                child: IconButton(
                                  onPressed: () {
                                    _scaffoldState.currentState!.openDrawer();
                                  },
                                  icon: Image.asset(
                                    "assets/images/profile.png",
                                    width: 27,
                                    height: 27,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            const SizedBox(width: 20.0),
                            Text(
                              "My wallet",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                            const SizedBox(
                              width: 25.0,
                            ),
                            IconButton(
                                onPressed: () async {
                                  historyTitle =
                                  (historyTitle == "" || historyTitle == null)
                                      ? "Crypto"
                                      : historyTitle;
                                  print(
                                      "=======================================${historyTitle}=======================================");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionScreen(title: historyTitle),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            PopupMenuButton(
                                iconColor: Colors.white,
                                color: Colors.grey[300],
                                itemBuilder: (context) =>
                                [
                                  PopupMenuItem(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            historyTitle = "Crypto";
                                            walletType = GlobalSettngs.cryptowalletname;
                                            setupState(GlobalSettngs.cryptowalletname);
                                          });
                                          print(
                                              "=======================================${historyTitle}=======================================");
                                          return;
                                        },
                                        child: Text("Crypto wallet"),
                                      )),
                                  PopupMenuItem(
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            historyTitle = "Stock";
                                            walletType = GlobalSettngs.sharewalletname;
                                            setupState(GlobalSettngs.sharewalletname);//tbd
                                          });
                                          print(
                                              "=======================================${historyTitle}=======================================");
                                          return;
                                        },
                                        child: Text("Stock wallet"),
                                      )),
                                  PopupMenuItem(
                                      child: TextButton(
                                        onPressed: () {
          
                                          setState(() {
                                            historyTitle = "Trade";
                                            walletType = GlobalSettngs.tradewalletname;
                                            setupState(GlobalSettngs.sharewalletname); //tbd
                                          });
                                          print(
                                              "=======================================${historyTitle}=======================================");
                                          return;
                                        },
                                        child: Text("Trade wallet"),
                                      )),
                                ]),
                          ],
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Type: ", style: TextStyle(
                                fontSize: 20.0, color: Colors.white), ),
                            Text(walletType, style: TextStyle(
                                fontSize: 20.0, color: Colors.white),)
                          ],
                        ),
          
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Available balance",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                               Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // Center the row horizontally
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "\$ ",
                                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown, // Changed fit property
                                          child: Text(
                                            formatedNumberString(WalletDataIfFound["amount"] ?? "0"),
                                            style: TextStyle(
                                              fontSize: 35.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(-2.0, -2.0),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(255, 13, 37, 108),//Color.fromARGB(255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(2.0, 2.0),
                                                  blurRadius: 8.0,
                                                  color: Color.fromARGB(255, 76, 116, 238),//Color.fromARGB(125, 0, 0, 255),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "\/-",
                                          style: TextStyle(fontSize: 35.0, color: Colors.white),
                                        ),
                                      ],
                                    ),
          
                                  ],
          
                              ),
                            ],
                          ),
                        ),
                      ),
          
                      Visibility(
                        visible: needToShowTransferAndWithdrawButtons,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50.0,
                                // decoration: BoxDecoration(
                                //   border: BoxDecoratinStyes.CustomeBorder,
                                //   color: Colors.grey[300],
                                //   borderRadius: BorderRadius.circular(3.0),
                                // ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                      color: Color.fromARGB(255,255,255,255),
                                      width: 2.0,
                                      style: BorderStyle.solid
                                  ),
          
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-10, -10),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      color: Colors.white,//Color.fromARGB(255, 255, 255, 255),
                                      inset: true,
                                    ),
                                    BoxShadow(
                                      offset: Offset(10, 10),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      color: Color.fromARGB(185, 138, 136, 136),//Color(0xFFD5D1D1),
                                      inset: true,
                                    ),
          
                                    BoxShadow(
                                      color: Color.fromARGB(255, 13, 37, 108),
                                      offset: const Offset(
                                        4.0,
                                        4.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Color.fromARGB(255, 76, 116, 238),
                                      offset: const Offset(-4, -4),
                                      blurRadius: 5.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    if(await AuthenticationHelper().isAuthenticated(context)){
                                      Navigator.push(
                                        context,
          
                                        await MaterialPageRoute(
                                            builder: (context) => PaymentScreen(WalletDataIfFound,walletType)),
                                      );
                                    }
          
                                  },
                                  child: Row(
                                    children: [
                                      Transform.rotate(
                                        angle: 135 * math.pi / 180,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: null,
                                        ),
                                      ),
                                      Text(
                                        "Transfer",
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                height: 50.0,
                                // decoration: BoxDecoration(
                                //     border: BoxDecoratinStyes.CustomeBorder,
                                //     color: Colors.grey[300],
                                //     borderRadius: BorderRadius.circular(3.0)),
          
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                      color: Color.fromARGB(255,255,255,255),
                                      width: 2.0,
                                      style: BorderStyle.solid
                                  ),
          
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-10, -10),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      color: Colors.white,//Color.fromARGB(255, 255, 255, 255),
                                      inset: true,
                                    ),
                                    BoxShadow(
                                      offset: Offset(10, 10),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      color: Color.fromARGB(185, 138, 136, 136),//Color(0xFFD5D1D1),
                                      inset: true,
                                    ),
          
                                    BoxShadow(
                                      color: Color.fromARGB(255, 13, 37, 108),
                                      offset: const Offset(
                                        4.0,
                                        4.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Color.fromARGB(255, 76, 116, 238),
                                      offset: const Offset(-4, -4),
                                      blurRadius: 5.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: ()async {
                                    if(await AuthenticationHelper().isAuthenticated(context)){
                                      Navigator.push(
                                        context,
                                        await MaterialPageRoute(
                                            builder: (context) => WithDrawScreen(WalletDataIfFound, walletType)),
                                      );
                                    }
                                  },
                                  // style: CustomeElevatedButtonStyle.customeStyle(
                                  //     Colors.blue[900], Colors.white, Colors.white),
                                  child: Row(
                                    children: [
                                      Transform.rotate(
                                        angle: 315 * math.pi / 180,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: null,
                                        ),
                                      ),
                                      Text(
                                        "Withdraw",
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !needToShowTransferAndWithdrawButtons,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border.all(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                  style: BorderStyle.solid,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(-10, -10),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    color: Colors.white,
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(10, 10),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    color: Color.fromARGB(185, 138, 136, 136),
                                    inset: true,
                                  ),
                                  BoxShadow(
                                    color: Color.fromARGB(255, 13, 37, 108),
                                    offset: const Offset(
                                      4.0,
                                      4.0,
                                    ),
                                    blurRadius: 5.0,
                                    spreadRadius: 5.0,
                                  ),
                                  BoxShadow(
                                    color: Color.fromARGB(255, 76, 116, 238),
                                    offset: const Offset(-4, -4),
                                    blurRadius: 5.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    await MaterialPageRoute(
                                      builder: (context) => PaymentScreen(WalletDataIfFound, walletType),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.rotate(
                                        angle: 135 * math.pi / 180,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: null,
                                        ),
                                      ),
                                      Text(
                                        "Add card",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                      border: Border.all(
                          color: Color.fromARGB(255,255,255,255),
                          width: 2.0,
                          style: BorderStyle.solid
                      ),
                            
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-10, -10),
                          blurRadius: 10,
                          spreadRadius: 5,
                          color: Colors.white,//Color.fromARGB(255, 255, 255, 255),
                          inset: true,
                        ),
                        BoxShadow(
                          offset: Offset(10, 10),
                          blurRadius: 10,
                          spreadRadius: 10,
                          color: Color.fromARGB(185, 138, 136, 136),//Color(0xFFD5D1D1),
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
                          color: Color.fromARGB(255, 101, 140, 248),
                          offset: const Offset(-4, -4),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Column(
                            
                          children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              walletType==GlobalSettngs.cryptowalletname?"My coins":"My stocks",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.blue[900]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10.0, right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: BoxDecoratinStyes.CustomeBorder,
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
                                      color: Color.fromARGB(255,255,255,255),
                                      offset: const Offset(-4, -4),
                                      blurRadius: 5.0,
                                      spreadRadius: 2.0,
                                    ), //BoxShadow
                                  ],
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add, color: Colors.blue[900]),
                                    onPressed: ()async {
                                      if(walletType==GlobalSettngs.cryptowalletname){
                                        Navigator.push(
                                          context,
                                          await MaterialPageRoute(builder: (context) => CryptoViewScreen()),
                                        );
                                      }
                                      if(walletType==GlobalSettngs.sharewalletname){
                                        //tbd
                                      }
                                      if(walletType==GlobalSettngs.tradewalletname){
                                        //tbd
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                           Expanded(
                             child:  ListView.builder(
                                shrinkWrap: true,
                                itemCount: myCryptoListToPopulate.length,
                                itemBuilder:(context, index) {
                                  return myCryptoListToPopulate.any((element) {
                                    return element!=null || element!="" || element!="0";
                                  },)&& myCryptoListCount == myCryptoListToPopulate.length? ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50.0),
                                        border: BoxDecoratinStyes.CustomeBorder,
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
                                            color: Color.fromARGB(255,255,255,255),
                                            offset: const Offset(-4, -4),
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0,
                                          ), //
                                        ],
                                        color: Colors.grey[300],
                                      ),
                                      child:Icon(
                                            CryptoCoinIcons.getCryptoIcon(
                                                myCryptoListToPopulate[index]['symbol']??"") !=
                                                null
                                                ? CryptoCoinIcons.getCryptoIcon(
                                                myCryptoListToPopulate[index]['symbol']??"")
                                                : Icons.circle,
                                            size: 40.0,
                                            color: Colors.grey[900],
                                          ),

                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("${ formatedNumberString(myCryptoListToPopulate[index]["quantity"].toString())} ", style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text("${myCryptoListToPopulate[index]["symbol"]??""}"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("\$${ formatedNumberString(myCryptoListToPopulate[index]["currentprice"].toString())}",style: TextStyle(fontSize: 15),),
                                            Text("  ${ formatedNumberString( myCryptoListToPopulate[index]["percentageofprofitandloss"].toString())}%", style: TextStyle(color: (!myCryptoListToPopulate[index]["isloss"]?Colors.red[900]:Colors.green[900]), fontSize: 15.0)),
                                          ],
                                        ),

                                      ],

                                    ),
                                    trailing: CustomeCharts(id:myCryptoListToPopulate[index]["id"]),
                                    //Text(double.parse(myCryptoListToPopulate[index]['marketpricepercentage'].toString()).toStringAsFixed(2), style: TextStyle(fontSize: 18, color:myCryptoListToPopulate[index]['marketpricepercentage'][0]=="-"?Colors.red[900]:Colors.green[900] ),),
                                    /* Row(
                                      children: [ CustomeCharts(id:myCryptoListToPopulate[index]["id"]),
                                        Column(
                                          children: [
                                            Text(double.parse(myCryptoListToPopulate[index]['marketprice'].toString()).toStringAsFixed(3)),
                                            Text(double.parse(myCryptoListToPopulate[index]['marketpricepercentage'].toString()).toStringAsFixed(2), style: TextStyle(fontSize: 18, color:myCryptoListToPopulate[index]['marketpricepercentage'][0]=="-"?Colors.red[900]:Colors.green[900] ),),
                                          ],
                                        ),
                                      ],
                                    ),*/

                                  ):Center(
                                    child: CupertinoActivityIndicator(
                                      color: Colors.blue[900],
                                      animating: true,
                                      radius: 20,
                                    ),
                                  );
                                }
                              ),
                              ),
                        ]),
                    ),
                  ),
                ),
              ],
            ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[300],
          onPressed: () async{
            if(walletType == GlobalSettngs.cryptowalletname){
              myCryptoListToPopulate = [];
              await getMyCoins("mycoins");
            }

          },
          child: Icon(Icons.refresh, color: Colors.blue[900],),
        ),

        drawer: CtmDrawer(),
      );
    }
  }
}
