import 'dart:async';
import 'dart:convert';
import 'package:crypto_viewer/pages/chart_view_screen.dart';
import 'package:cryptocoins_icons/cryptocoins_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../custome_component_style/box_decoration.dart';
import 'mywallet_view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class CryptoViewScreen extends StatefulWidget {
  const CryptoViewScreen({Key? key}) : super(key: key);

  @override
  State<CryptoViewScreen> createState() => _CryptoViewScreenState();
}

class _CryptoViewScreenState extends State<CryptoViewScreen> {
  double _screenWidth = 0.0;
  late List<CryptoData> cryptoDataList;

  @override
  void initState() {
    super.initState();
    cryptoDataList = [];
    getRequest(); // Initial call to fetch data
    // Start a timer to refresh data every second
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      getRequest();
    });
  }

  Future<void> getRequest() async {
    String url = "https://api.coincap.io/v2/assets";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    List<CryptoData> updatedCryptoDataList = [];
    for (var item in responseData['data']) {
      CryptoData cryptoData = CryptoData(
          id: item["id"],
          rank: item["rank"],
          symbol: item["symbol"],
          name: item["name"],
          supply: item["supply"],
          maxSupply: item["maxSupply"],
          marketCapUsd: item["marketCapUsd"],
          volumeUsd24Hr: item["volumeUsd24Hr"],
          priceUsd: item["priceUsd"],
          changePercent24Hr: item["changePercent24Hr"],
          vwap24Hr: item["vwap24Hr"]);
      updatedCryptoDataList.add(cryptoData);
    }
    setState(() {
      cryptoDataList = updatedCryptoDataList;
    });
  }

  String showPrice(String price) {
    double cryptoPrice = double.parse(price);
    String stringValue = cryptoPrice.toStringAsFixed(2);
    double newValue = double.parse(stringValue);
    return newValue.toString();
  }

  Color? isInMinus(String price) {
    if (price[0] == "-") {
      return Colors.red[800]!;
    } else {
      return Colors.green[900];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _screenWidth = screenWidth;

    return Scaffold(
      appBar: AppBar(
        centerTitle:true,
          leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.wallet, size: 40,),
            onPressed: (){
              Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyWalletScreen(),
                    ),
                  );
            },
          ),
        ),
        foregroundColor: const Color.fromARGB(255, 234, 234, 234),
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 41, 91, 172),
        title: Center(
          child: const Text(
            "Crypto view",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SizedBox(
        width: _screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cryptoDataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: const Color.fromARGB(255, 234, 234, 234),
                    leading: Container(
                      width: 100.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 91, 172),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                        border: BoxDecoratinStyes.CustomeBorder,
                      ),
                      child: Center(
                          child: Row(
                        children: [
                          // CryptoIcons.loadAsset(cryptoDataList[index].symbol?.toUpperCase()?? "ETH", 20),
                          const SizedBox(width: 10.0),
                          Icon(
                            CryptoCoinIcons.getCryptoIcon(
                                        cryptoDataList[index].symbol!) !=
                                    null
                                ? CryptoCoinIcons.getCryptoIcon(
                                    cryptoDataList[index].symbol!)
                                : Icons.circle,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            cryptoDataList[index].symbol?.toUpperCase() ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                    ),
                    title:
                        Text(cryptoDataList[index].name ?? ""), //Id as a name
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Text(
                          '\$ ${showPrice(cryptoDataList[index].priceUsd!)}',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          height: 30,
                          width: 60,
                          decoration: BoxDecoration(
                            color:isInMinus(showPrice(
                                    cryptoDataList[index].changePercent24Hr!)
                                    ),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                            border: BoxDecoratinStyes.CustomeBorder,
                                  ),
                          child: Text(
                            showPrice(cryptoDataList[index].changePercent24Hr!),
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      // String id = cryptoDataList[index].id ?? "";
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ChartView(urlOfSpacificCrypto: id),
                      //   ),
                      // );
                    },
                    trailing: Container(
                      decoration: BoxDecoration(
                        border: BoxDecoratinStyes.CustomeBorder,
                        boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_outlined),
                          onPressed: () {
                            String id = cryptoDataList[index].id ?? "";
                            CryptoData data = cryptoDataList[index];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChartView(urlOfSpacificCrypto: id, data:data, name:"old"),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
