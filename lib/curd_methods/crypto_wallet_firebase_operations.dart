
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto_viewer/pages/mywallet_view_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custome_component_style/alert.dart';
import '../services/firebase_service.dart';

class CryptoWalletFirebaseOperation{

  //wallet operation for both crypto and stock
  static Future<bool> addAmountToTheWallet(var data, BuildContext context, String walleteType) async {
    bool isOk = false;
    try {
      // Check if user is authenticated
      final isAuthenticated = await AuthenticationHelper().isAuthenticated(context);
      if (!isAuthenticated) {
        CutomeAlert.showErrorAlert(context, "You are not authenticated");
        return isOk; // Return false immediately if not authenticated
      }

      final user = AuthenticationHelper().user;
      final uid = user.uid;

      if(await isWalletFound(uid, walleteType)){
        var privWalletData= await getCryptoWalletDataFromFirebaseCollection(walleteType);
        double privBalance = privWalletData!=null? double.parse(privWalletData[0]["amount"]):0;
        double addonBalance = double.parse(data["amount"]);
        double totalBalance = privBalance+addonBalance;
        try{
          FirebaseFirestore.instance.collection(walleteType).where('createdbyuid', isEqualTo: uid).get().then((querySnapshot)
          {
            querySnapshot.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection(walleteType)
                  .doc(element.id)
                  .update(
                {
                  'amount': totalBalance.toString(),
                  'updatedon': DateTime.now()
                },
              );//FieldValue.increment(1)
            });

          });
          await CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Your transaction was successful!",
          );
          return true;

        }
        catch(e){
          print("------------------------------------------crypto wallet updating data error: $e--------------------------------");
        }

        return true;

      }

      print("data not found");
      print('-------------------------------------------------$uid-----------------------------------------');
      FirebaseFirestore.instance.collection("/$walleteType").add({
        "fullname": data["fullname"],
        "cardno": data["cardno"],
        "validupto": data["validupto"],
        "cvv": data["cvv"],
        "amount": data["amount"],
        "createdbyuid":uid,
        "walletname":walleteType,
        "createdonutc":DateTime.now(),
        "updatedonutc":DateTime.now(),
      }).catchError((err) {
        print('------------------------------------Error: $err---------------------------------'); // Prints 401.
      }, test: (error) {
        return error is int && error >= 400;
      });
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Your transaction was successful!",
      );
      print("-------------------Amount added to the wallet-----------------\n\n \n\n");
      isOk = true;
    }
    catch (e)
    {
      isOk = false;
      print("-------------------Exception caught while adding amount to the wallet-----------------\n\n $e \n\n");
    }

    return isOk;
  }
  static Future<bool> isWalletFound(var uid, var collectionName)async{
    bool isFound = false;
    try{
      var collection = FirebaseFirestore.instance.collection(collectionName);
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if(data["createdbyuid"]!=null && data['createdbyuid'] == uid){
          isFound = true;
          break;
        }
        else{
          print("------------------------------------------$collectionName wallet not found--------------------------------");
          isFound = false;
        }
      }
    }
    catch(e){
      isFound = false;
      print("------------------------------------------crypto wallet finding data error $e--------------------------------");
    }
    return isFound;
  }
  static Future<List<Map<String, dynamic> >> getCryptoWalletDataFromFirebaseCollection(String collectionName)async{
    var collection = FirebaseFirestore.instance.collection(collectionName);
    var querySnapshot = await collection.get();

    List<Map<String, dynamic> > WalletMapDataList = [];

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      WalletMapDataList.add(queryDocumentSnapshot.data());
      // var name = data['name'];
      // var phone = data['phone'];
    }
    return WalletMapDataList;
  }
  static Future<void> updateWalletAmount(var uid, var wallettype, var updatedonutc, var updatedamount, var context) async{
    try{
      FirebaseFirestore.instance.collection(wallettype).where('createdbyuid', isEqualTo: uid).get().then((querySnapshot)
      {
        querySnapshot.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection(wallettype)
              .doc(element.id)
              .update(
            {
              'amount': updatedamount.toString(),
              'updatedon': updatedonutc,
            },
          );//FieldValue.increment(1)
        });

      });
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Your transaction was successful!",
      );
      Navigator.pushReplacement(
        context,
        await MaterialPageRoute(builder: (context) => MyWalletScreen()),
      );

    }
    catch(e){
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Your transaction was failed!",
      );
      Navigator.pop(context);
      print("------------------------------------------crypto wallet updating data error: $e--------------------------------");
    }
  }

  //buy or sell crypto
  static Future<bool> isMyCoinsFound(var uid, var collectionName, var name, var symbol)async{
    bool isFound = false;
    try{
      var collection = FirebaseFirestore.instance.collection(collectionName);
      var querySnapshot = await collection.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        if(data["created_by_uid"]!=null && data['created_by_uid'] == uid){
          if(data["name"]==name && data["symbol"]==symbol){
            isFound = true;
            break;
          }
        }
        else{
          print("------------------------------------------$collectionName coin not found--------------------------------");
          isFound = false;
        }
      }
    }
    catch(e){
      isFound = false;
      print("------------------------------------------crypto coin finding data error $e--------------------------------");
    }
    return isFound;
  }
  static Future<List<Map<String, dynamic> >> getMyCoinsDataFromFirebaseCollection(String collectionName)async{
    var collection = FirebaseFirestore.instance.collection(collectionName);
    var querySnapshot = await collection.get();

    List<Map<String, dynamic> > myCoinsDataList = [];

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      myCoinsDataList.add(queryDocumentSnapshot.data());
      // var name = data['name'];
      // var phone = data['phone'];
    }
    return myCoinsDataList;
  }
  static Future<void> buyCrypto(var context, var amount, var waltype, var WalletDataIfFound, var cryptoData, var totalamt)async{
    final user = AuthenticationHelper().user;
    final uid = user.uid;

    var availabelBal = double.parse(WalletDataIfFound["amount"]);
    var transactionRemainingAmount = availabelBal-totalamt;
    if(transactionRemainingAmount<0){
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Insufficient wallet balance!",
      );
      return;
    }

    var transactionId = "CNRB1546879235";//tbd
    var createdBy = uid;
    var buy = true;
    var wallettype = waltype;
    var createdOnUtc = DateTime.now();
    var name = cryptoData["name"];
    var symbol = cryptoData["symbol"];
    var quantity = amount;
    var value = cryptoData["priceUsd"];

    await updateWalletAmount(createdBy, wallettype, createdOnUtc, transactionRemainingAmount, context);
    await addOrUpdateMyCoins(createdBy, createdOnUtc, "mycoins", quantity, cryptoData, totalamt, context);
    FirebaseFirestore.instance.collection("/transactions").add({
      "name":name,
      "symbol": symbol,
      "value": value,
      "purchased_coin": quantity,
      "price_usd_paid": totalamt,
      "date_time": createdOnUtc.toString(),
      "transaction_id": transactionId,
      "bought": buy,
      "availabel_balence":transactionRemainingAmount,
      "created_by_uid":createdBy,
      "wallet_type":wallettype,
    }).catchError((err) {
      print('------------------------------------Error: $err---------------------------------'); // Prints 401.
    }, test: (error) {
      return error is int && error >= 400;
    });



  }
  static Future<void> sellCrypto()async{

  }
  static Future<void> addOrUpdateMyCoins(var createdBy, var createdOnUtc, var collectionname, var quantity, var cryptoData, var totalamt, var context)async{
    try{
      if(await isMyCoinsFound(createdBy, collectionname, cryptoData["name"], cryptoData["symbol"])) {
        var listOfCoins = await getMyCoinsDataFromFirebaseCollection(collectionname);
        if(listOfCoins!=null || listOfCoins.length!=0){
          var cointoupdate = {};
          for(var coin in listOfCoins){
            if(coin["name"] == cryptoData["name"] && coin["symbol"] == cryptoData["symbol"] && coin["created_by_uid"] == createdBy){
              cointoupdate = coin;
              break;
            }
          }
          if(cointoupdate!=null) {
            try {
              var availabelCoinCounts = double.parse(cointoupdate["quantity"].toString());
              var totalCoins = availabelCoinCounts + quantity;
              var privioustotalamountpaid = double.parse(cointoupdate["totalamountpaid"].toString());
              var totalamountpaid = totalamt + privioustotalamountpaid;

              FirebaseFirestore.instance.collection(collectionname)
                  .where("id", isEqualTo: cointoupdate["id"].toString())
                  .get().then((querySnapshot) {
                querySnapshot.docs.forEach((element) {
                  FirebaseFirestore.instance
                      .collection(collectionname)
                      .doc(element.id)
                      .update({
                    'quantity': totalCoins.toString(),
                    'totalamountpaid': totalamountpaid.toString(),
                    'date_time': createdOnUtc.toString(),
                  });
                });
              });

              // FirebaseFirestore.instance.collection(collectionname).where(
              //     '', isEqualTo: cointoupdate["id"].toString()).get().then((querySnapshot) {
              //   querySnapshot.docs.forEach((element) {
              //     FirebaseFirestore.instance
              //         .collection(collectionname)
              //         .doc(element.id)
              //         .update(
              //       {
              //         'quantity': totalCoins.toString(),
              //         'totalamountpaid': totalamountpaid.toString(),
              //         'date_time': createdOnUtc.toString(),
              //       },
              //     ); //FieldValue.increment(1)
              //   });
              // });

              await CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                text: "Your coins added successful!",
              );
              Navigator.pushReplacement(
                context,
                await MaterialPageRoute(builder: (context) => MyWalletScreen()),
              );
            }
            catch (e) {

            }
          }
          else{
            //coins for update not found
          }
        }
        else{
          //list of coins not found
        }

      }
      else{

        //create the table and insert the new coin
        FirebaseFirestore.instance.collection("/mycoins").add({
          "id":cryptoData["id"],
          "name":cryptoData["name"],
          "symbol": cryptoData["symbol"],
          "quantity": quantity,
          "totalamountpaid": totalamt.toString(),
          "date_time": createdOnUtc.toString(),
          "created_by_uid":createdBy,
        }).catchError((err) {
          print('------------------------------------Error: $err---------------------------------'); // Prints 401.
        }, test: (error) {
          return error is int && error >= 400;
        });
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Your coins added in your wallet successful!",
        );
      }
    }
    catch(e){

    }
  }

  //buy or sell stock
  static Future<void> buyStock()async{

  }
  static Future<void> sellStock()async{

  }
  static Future<void> addOrUpdateMyStocks()async{

  }

  //banking:
  static Future<void>addBankAccount(String accno, String ifsccode)async{
    // if(isBankAccountFound(accno, ifsccode){
    //   await CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.info,
    //     text: "Bank account alrady added!",
    //   );
    // }
  }
  static Future<void>isBankAccountFound(String accno, String ifsccode)async{

  }

}

