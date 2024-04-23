import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocoins_icons/cryptocoins_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../custome_component_style/box_decoration.dart';

class Data{
  final String name;
  final String symbol;
  final double value;
  final double purchasedCoin;
  final double priceUsdPaid;
  final String dateTime;
  final String transactionId;
  final bool bought;
  // final bool isDone = false;

  Data(this.name,
      this.symbol,
      this.value,
      this.purchasedCoin,
      this.priceUsdPaid,
      this.dateTime,
      this.transactionId,
      this.bought,
      );
}

class TransactionScreen extends StatefulWidget {
  final title;
  TransactionScreen({required this.title});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  //number to month map;

  TextEditingController _searchController = new TextEditingController();
  var historyDataAccordingToTitle = [];
  var copyOfhistoryDataAccordingToTitle = [];
  var dummydatalist = [];
  // var dummydatalist = [
  //   {"name":"bitcoin", "symbol":"BTC", "value":70858.60, "purchased_coin":0.00001, "price_usd_paid":0.71, "date_time":"03/26/2024 17:1pm","transaction_id":"CNRB555654dsfa556", "bought":true},
  //   {"name":"ethereum", "symbol":"ETH", "value":3260.45, "purchased_coin":0.001, "price_usd_paid":3.26, "date_time":"03/26/2024 17:15pm","transaction_id":"ERTG123456asfd789", "bought":false},
  //   {"name":"litecoin", "symbol":"LTC", "value":204.89, "purchased_coin":0.01, "price_usd_paid":2.04, "date_time":"03/26/2024 17:30pm","transaction_id":"LTCP987654gfds321", "bought":false},
  //   {"name":"ripple", "symbol":"XRP", "value":1.08, "purchased_coin":100, "price_usd_paid":0.0108, "date_time":"03/26/2024 17:45pm","transaction_id":"XRPC456789lkjh987", "bought":true},
  //   {"name":"chainlink", "symbol":"LINK", "value":24.76, "purchased_coin":0.1, "price_usd_paid":0.2476, "date_time":"03/26/2024 18:00pm","transaction_id":"LNKC345678qwer123", "bought":false},
  //   {"name":"cardano", "symbol":"ADA", "value":1.34, "purchased_coin":50, "price_usd_paid":0.0268, "date_time":"03/26/2024 18:15pm","transaction_id":"ADAF567890poi987", "bought":false},
  //   {"name":"stellar", "symbol":"XLM", "value":0.60, "purchased_coin":500, "price_usd_paid":0.0012, "date_time":"03/26/2024 18:30pm","transaction_id":"XLMP432109mnbv876", "bought":true},
  //   {"name":"polkadot", "symbol":"DOT", "value":25.89, "purchased_coin":0.05, "price_usd_paid":0.5178, "date_time":"03/26/2024 18:45pm","transaction_id":"DOTY987654lkjh321", "bought":false},
  //   {"name":"dogecoin", "symbol":"DOGE", "value":0.101, "purchased_coin":1000, "price_usd_paid":0.000101, "date_time":"03/26/2024 19:00pm","transaction_id":"DOGZ345678poiu098", "bought":true},
  //   {"name":"solana", "symbol":"SOL", "value":86.25, "purchased_coin":0.005, "price_usd_paid":17.25, "date_time":"03/26/2024 19:15pm","transaction_id":"SOLL123456ytrew987", "bought":false}
  // ];

  //var transactionList = [];


  void getTransactionData()async{
    var collection = FirebaseFirestore.instance.collection("transactions");
    var querySnapshot = await collection.get();

    List<Map<String, dynamic> > transactiondatalist = [];

    for (var queryDocumentSnapshot in querySnapshot.docs) {
      transactiondatalist.add(queryDocumentSnapshot.data());
      // var name = data['name'];
      // var phone = data['phone'];
    }


    for (var i in transactiondatalist) {
      historyDataAccordingToTitle.add(Data(
          i["name"].toString(),
          i["symbol"].toString(),
          double.parse(i["value"].toString()),
          double.parse(i["purchased_coin"].toString()),
          double.parse(i["price_usd_paid"].toString()),
          i["date_time"].toString(),
          i["transaction_id"].toString(),
          bool.parse(i["bought"].toString())
      ));
    }
    copyOfhistoryDataAccordingToTitle = historyDataAccordingToTitle;
    dummydatalist = historyDataAccordingToTitle;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO: init history data here from firebase database
    getTransactionData();

  }
  @override
  Widget build(BuildContext context) {
    if(widget.title == "" || widget.title == null){
      print("=======================================title is null in history======================================");
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor:Colors.red[700],
          title: const Text("Fail", style: TextStyle(color: Colors.white),),
          content: const Text("Something went wrong", style: TextStyle(color: Colors.white)),
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
      Navigator.pop(context);
    }
    if(widget.title == "Crypto"){
      print("=======================================${widget.title}=======================================");
    }
    if(widget.title == "Stock"){
      print("=======================================${widget.title}=======================================");
    }
    if(widget.title == "Trade"){
      print("=======================================${widget.title}=======================================");
    }
    var isloading = false;

    return (isloading == true) ? Center(
      child:LinearProgressIndicator(),
    ): Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(

        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white, size: 25.0,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("History",style:TextStyle(fontSize: 25.0, color: Colors.white)),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isloading = true;
            });

            var serachingText = _searchController.text.toLowerCase();
            historyDataAccordingToTitle = [];
            if(serachingText.isEmpty){
              historyDataAccordingToTitle = copyOfhistoryDataAccordingToTitle;
            }
            for (var i in dummydatalist) {
              if(i["name"].toString().toLowerCase().contains(serachingText)){
                historyDataAccordingToTitle.add(Data(
                    i["name"].toString(),
                    i["symbol"].toString(),
                    double.parse(i["value"].toString()),
                    double.parse(i["purchased_coin"].toString()),
                    double.parse(i["price_usd_paid"].toString()),
                    i["date_time"].toString(),
                    i["transaction_id"].toString(),
                    bool.parse(i["bought"].toString())
                ));
              }
            }
            setState(() {
              isloading = false;
            });
          }, icon: Icon(CupertinoIcons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0),
              height: 60.0,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: BoxDecoratinStyes.CustomeBorder, // Corrected this line
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: BoxDecoratinStyes.CustomeBoxshadow
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.grey[900],
                      style: TextStyle(color: Colors.grey[900], fontSize: 20.0),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    width: 45.0,
                    height: 45.0,

                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                      border: BoxDecoratinStyes.CustomeBorder,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () async{
                          setState(() {
                            isloading = true;
                          });

                          var serachingText = _searchController.text.toLowerCase();
                          historyDataAccordingToTitle = [];
                          if(serachingText.isEmpty){
                            historyDataAccordingToTitle = copyOfhistoryDataAccordingToTitle;
                          }
                          for (var i in dummydatalist) {
                            if(i["name"].toString().toLowerCase().contains(serachingText)){
                              historyDataAccordingToTitle.add(Data(
                                  i["name"].toString(),
                                  i["symbol"].toString(),
                                  double.parse(i["value"].toString()),
                                  double.parse(i["purchased_coin"].toString()),
                                  double.parse(i["price_usd_paid"].toString()),
                                  i["date_time"].toString(),
                                  i["transaction_id"].toString(),
                                  bool.parse(i["bought"].toString())
                              ));
                            }
                          }
                          setState(() {
                            isloading = false;
                          });
                        },
                        icon: Icon(CupertinoIcons.search, color: Colors.grey[900], size: 25.0,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0,)
                ],
              ),
            ),
            const SizedBox(height: 10.0,),
            historyDataAccordingToTitle.length!=0?Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: historyDataAccordingToTitle.length,
                  itemBuilder:(context, index) {
                    return ListTile(
                        leading: Container(
                          padding: EdgeInsets.zero,
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              border: BoxDecoratinStyes.CustomeBorder,
                              boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          child:  Icon(
                            CryptoCoinIcons.getCryptoIcon(
                                historyDataAccordingToTitle[index].symbol.toString()) !=
                                null
                                ? CryptoCoinIcons.getCryptoIcon(
                                historyDataAccordingToTitle[index].symbol.toString())
                                : Icons.circle,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('${historyDataAccordingToTitle[index].name}'),
                        subtitle:Text('${historyDataAccordingToTitle[index].dateTime}'),
                        trailing: Text('\$${historyDataAccordingToTitle[index].priceUsdPaid.toStringAsFixed(2)}', style: TextStyle(fontSize: 20.0, color: (historyDataAccordingToTitle[index].bought ? Colors.red[900] : Colors.green[900])) ,),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      children: [
                                        Text("Transaction Details", textAlign: TextAlign.center, style: TextStyle(
                                            color: Colors.grey[900],
                                            fontSize: 20.0
                                        ),),
                                        const SizedBox(height: 20.0,),
                                        Container(
                                          padding: EdgeInsets.zero,
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                              color: Colors.blue[900],
                                              border: BoxDecoratinStyes.CustomeBorder,
                                              boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                              borderRadius: BorderRadius.circular(30.0)
                                          ),
                                          child:  Icon(
                                            CryptoCoinIcons.getCryptoIcon(
                                                historyDataAccordingToTitle[index].symbol.toString()) !=
                                                null
                                                ? CryptoCoinIcons.getCryptoIcon(
                                                historyDataAccordingToTitle[index].symbol.toString())
                                                : Icons.circle,
                                            size: 40.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0,),
                                        Text("${historyDataAccordingToTitle[index].name}",  textAlign: TextAlign.center, style: TextStyle(
                                          color: Colors.grey[900], fontWeight: FontWeight.bold,
                                        ),),
                                        const SizedBox(height: 10.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("\$  ",  textAlign: TextAlign.center, style: TextStyle(
                                                color: historyDataAccordingToTitle[index].bought? Colors.red[900] : Colors.green[900], fontWeight: FontWeight.bold, fontSize: 20.0
                                            ),),
                                            Text("${historyDataAccordingToTitle[index].priceUsdPaid}",  textAlign: TextAlign.center, style: TextStyle(
                                              color: historyDataAccordingToTitle[index].bought? Colors.red[900] : Colors.green[900], fontWeight: FontWeight.bold, fontSize: 30.0,
                                            ),),
                                            const SizedBox(height: 20.0,),
                                            // Row(
                                            //   children: [
                                            //     historyDataAccordingToTitle[index].isDone?
                                            //     Container(
                                            //         height:20.0,
                                            //         width:20.0,
                                            //         decoration:BoxDecoration(
                                            //           border: BoxDecoratinStyes.CustomeBorder,
                                            //           boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                            //           borderRadius: BorderRadius.circular(30.0),
                                            //           color: Colors.grey[300],
                                            //         ),
                                            //         child: Icon(Icons.done, color: Colors.green[900])) :
                                            //     Container(
                                            //         height:20.0,
                                            //         width:20.0,
                                            //         decoration:BoxDecoration(
                                            //           border: BoxDecoratinStyes.CustomeBorder,
                                            //           boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                            //           borderRadius: BorderRadius.circular(30.0),
                                            //           color: Colors.grey[300],
                                            //         ),
                                            //         child: Icon(Icons.close, color: Colors.red[900])),
                                            //
                                            //     const SizedBox(width: 10.0,),
                                            //     historyDataAccordingToTitle[index].isDone ? Text("Completed") : Text("Faild/Incompleted"),
                                            //   ],
                                            // ),

                                          ],
                                        ),
                                        const SizedBox(width: 10.0,),
                                        Text("${historyDataAccordingToTitle[index].dateTime}", style: TextStyle(fontSize: 20.0, color: Colors.grey[900]),),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 1.0,
                                          color: Colors.grey[500],
                                        ),

                                        const SizedBox(width: 30.0,),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                border: BoxDecoratinStyes.CustomeBorder,
                                                boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                                borderRadius: BorderRadius.circular(30.0)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Column(
                                                children: [
                                                  Text("Transaction Id", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                  Text("${historyDataAccordingToTitle[index].transactionId}", style: TextStyle(fontSize: 20.0),),
                                                  const SizedBox(height: 10.0,),

                                                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                  Text("${historyDataAccordingToTitle[index].name}", style: TextStyle(fontSize: 20.0),),
                                                  const SizedBox(height: 10.0,),

                                                  Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                  Text("${historyDataAccordingToTitle[index].purchasedCoin}", style: TextStyle(fontSize: 20.0),),
                                                  const SizedBox(height: 10.0,),

                                                  Container(
                                                    width: 300,
                                                    height: 100,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("Bought", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                            historyDataAccordingToTitle[index].bought ? Icon(Icons.done, color: Colors.grey[900]) : Icon(Icons.close, color: Colors.grey[900],),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 10.0,),

                                                        Column(
                                                          children: [
                                                            Text("Sell", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                            historyDataAccordingToTitle[index].bought ? Icon(Icons.close, color: Colors.grey[900]) : Icon(Icons.done, color: Colors.grey[900],),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10.0,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    Container(
                                      height:50.0,
                                      width:50.0,
                                      decoration:BoxDecoration(
                                        border: BoxDecoratinStyes.CustomeBorder,
                                        boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Colors.grey[300],
                                      ),
                                      child: IconButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, icon: Icon(CupertinoIcons.down_arrow, color: Colors.grey[900],)),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                    );
                  }
              ),
            ):Center(
                child: CupertinoActivityIndicator(
                  color: Colors.blue[900],
                  animating: true,
                  radius: 20,
                ),
              // );
              //child: CircularProgressIndicator());
            ),
          ],
        ),
      ),
    );
  }
}

