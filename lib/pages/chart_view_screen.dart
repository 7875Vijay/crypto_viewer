import 'dart:async';
import 'dart:convert';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_viewer/custome_component_style/box_decoration.dart';
import 'package:crypto_viewer/custome_component_style/elevated_button_style.dart';
import 'package:cryptocoins_icons/cryptocoins_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoData {
  final String? priceUsd;
  final int? time;
  final String? date;

  CryptoData({
    this.priceUsd,
    this.time,
    this.date,
  });
}


class ChartView extends StatefulWidget {
  final String urlOfSpacificCrypto;

  var data;
  var name;

  ChartView({required this.urlOfSpacificCrypto, required this.data, required this.name});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  var cryptoDataList = [];
 
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      getRequest();
      getSpecificData();
    });
  }

  Future<void> getRequest() async {
    if (widget.urlOfSpacificCrypto.isEmpty) {
      return; // Return if URL is empty or null
    }

    String url = 'https://api.coincap.io/v2/assets/${widget.urlOfSpacificCrypto}/history?interval=d1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        var updatedCryptoDataList = [];
        for (var item in responseData['data']) {
          CryptoData cryptoData = CryptoData(
              priceUsd: item["priceUsd"],
              date: item["date"],
              time: item["time"]
          );
          updatedCryptoDataList.add(cryptoData);
        }

        setState(() {
          cryptoDataList = updatedCryptoDataList;
        });
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network error
      print('Network Error: $error');
    }
  }

  Future<void> getSpecificData() async {

    String url = 'https://api.coincap.io/v2/assets/${widget.urlOfSpacificCrypto}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        //responseData["data"].rank = 010101;

        setState(() {
          widget.name = "new";
          widget.data = responseData["data"];

          //new ChartView(urlOfSpacificCrypto:widget.urlOfSpacificCrypto, data:responseData["data"], name:"new");
          //print("my data is this=> ${widget.data['priceUsd']} ${widget.name}");
        });


      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Network Error: $error');
    }
  }


  Color? isInMinus(String price) {
    if (price.startsWith("-")) {
      return Colors.red[800];
    } else {
      return Colors.green[900];
    }
  }

  String showPrice(String price) {
    double cryptoPrice = double.parse(price);
    String stringValue = cryptoPrice.toStringAsFixed(2);
    double newValue = double.parse(stringValue);
    return newValue.toString();
  }

  @override
  Widget build(BuildContext context) {
     if(widget.data == null){
       return Center(
         child: CupertinoActivityIndicator(
           color: Colors.blue[900],
           animating: true,
           radius: 20,
         ),
       );
     }
     else{
       List<double> listoflinedat = cryptoDataList.map((data) => double.parse(data.priceUsd)).toList();
       //("list data=> ${listoflinedat}");
       return Scaffold(
         appBar: AppBar(title: Text(widget.urlOfSpacificCrypto[0].toUpperCase()+widget.urlOfSpacificCrypto.substring(1,widget.urlOfSpacificCrypto.length )),
           foregroundColor: const Color.fromARGB(255, 234, 234, 234),
           elevation: 0.0,
           backgroundColor: Color.fromARGB(255, 41, 91, 172),
           centerTitle:true,
         ),
         body: Container(
           height: double.infinity,
           color: Colors.grey[300],
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Container(
                     margin: EdgeInsets.all(10),
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: Colors.grey[300],
                       border: BoxDecoratinStyes.CustomeBorder,
                       boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     child: Column(
                       children: [
                         Row(
                           children: [
                             Container(
                               width: 70,
                               height: 70,

                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50.0),
                                 border: BoxDecoratinStyes.CustomeBorder,
                                 boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                 color: Colors.grey[300],
                               ),
                               child: Icon(
                                 CryptoCoinIcons.getCryptoIcon(
                                     widget.data["symbol"]!) !=
                                     null
                                     ? CryptoCoinIcons.getCryptoIcon(
                                     widget.data["symbol"]!)
                                     : Icons.circle,
                                 size: 70.0,
                                 color: Colors.grey[900],
                               ),
                             ),
                             SizedBox(width: 15.0,),

                             Container(
                               child: Row(
                                 children: [
                                   Text("\$", style: TextStyle(fontSize: 20.0),),
                                   Text(showPrice(widget.data["priceUsd"]), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)
                                 ],
                               ),
                             ),

                             SizedBox(width: 10.0,),

                             Container(
                               padding: EdgeInsets.all(3),
                               height: 30,
                               width: 60,
                               decoration: BoxDecoration(
                                 color:isInMinus(showPrice(
                                     widget.data["changePercent24Hr"]!)
                                 ),
                                 borderRadius: BorderRadius.circular(10.0),
                                 boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                 border: BoxDecoratinStyes.CustomeBorder,
                               ),
                               child: Text(
                                 showPrice(widget.data["changePercent24Hr"]!),
                                 style: TextStyle(
                                     fontSize: 17.0,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.white),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ],
                         ),
                         SizedBox(width: 10.0,),
                         Column(
                           children: [
                             SizedBox(height: 9.0,),
                             Container(
                               padding: EdgeInsets.all(10.0),

                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 border: BoxDecoratinStyes.CustomeBorder,
                                 boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                                 color: Colors.grey[300],
                               ),
                               child: Column(
                                 children: [
                                   Column(children: [
                                     Text("Volume", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),  Text(showPrice(widget.data["volumeUsd24Hr"]), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue[900]),)
                                   ],),
                                   Container(height: 1.0,width: double.infinity ,color: Colors.grey[900],),
                                   Column(children: [
                                     Text("Market CapUSD", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), Text(showPrice(widget.data["marketCapUsd"]), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0, color: Colors.blue[900]),)
                                   ],),
                                   Container(height: 1.0,width: double.infinity ,color: Colors.grey[900],),
                                   Column(children: [
                                     Text("Average Prc.24H", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), Text(showPrice(widget.data["vwap24Hr"]), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0, color: Colors.blue[900]),)
                                   ],),

                                   Container(height: 1.0,width: double.infinity ,color: Colors.grey[900],),
                                   Column(children: [
                                     Text("Supply", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), Text(showPrice(widget.data["supply"]), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0, color: Colors.blue[900]),)
                                   ],),
                                 ],

                               ),
                             ),
                           ],
                         )
                       ],
                     ),

                   ),
                   Container(
                     height: 200,
                     margin: EdgeInsets.all(10),
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color:Color.fromRGBO(25, 25, 25, 70),
                       border: BoxDecoratinStyes.CustomeBorder,
                       boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     child: Column(
                       children: [
                         Text(
                           'History',
                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                         ),
                         SizedBox(height: 20),
                         Expanded(
                           child: Container(

                             padding: EdgeInsets.all(10.0),
                             child:Sparkline(
                               data: listoflinedat,

                               useCubicSmoothing: true,
                               cubicSmoothingFactor: 0.2,
                               //fillMode: FillMode.below,

                               gridLinelabelPrefix: '\$',
                               gridLineLabelPrecision: 3,
                               gridLineLabelColor: Colors.white,
                               enableGridLines: true,

                               pointsMode: PointsMode.last,
                               pointIndex: 7,
                               pointSize: 8.0,
                               pointColor: Colors.amber,

                               // fillGradient: LinearGradient(
                               //   begin: Alignment.topCenter,
                               //   end: Alignment.bottomCenter,
                               //   colors: [Colors.blue[900]!, Colors.blue[50]!],
                               //
                               // ),
                             ),
                             // child: LineChart(
                             //   LineChartData(
                             //     borderData: FlBorderData(show: true),
                             //     lineBarsData: [
                             //       LineChartBarData(
                             //         spots: cryptoDataList.asMap().entries.map((entry) {
                             //           return FlSpot(entry.key.toDouble(), double.parse(entry.value.priceUsd ?? "0.0"));
                             //         }).toList(),
                             //         isCurved: true,
                             //         color: Colors.green[900],
                             //         barWidth: 1,
                             //         isStrokeCapRound: true,
                             //         belowBarData: BarAreaData(show: false),
                             //
                             //       ),
                             //     ],
                             //     minY: 0,
                             //     lineTouchData: LineTouchData(enabled: true),
                             //     gridData: FlGridData(show: false),
                             //
                             //   ),
                             // ),
                           ),
                         ),

                       ],
                     ),

                   ),
                   const SizedBox(height: 30.0,),
                   Center(
                     child: Row(
                       mainAxisAlignment:MainAxisAlignment.center,
                       children: [
                         Container(
                           width: 100.0,
                           height: 50.0,
                           decoration: BoxDecoration(
                           boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                           border: BoxDecoratinStyes.CustomeBorder,
                           color: Colors.grey[300],
                           borderRadius: BorderRadius.circular(30.0),
                           ),
                           child: ElevatedButton(onPressed: (){},
                             style: CustomeElevatedButtonStyle.customeStyle(Colors.red[400], Colors.white, Colors.white),
                             child: Text("Buy", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),

                           ),
                         ),
                         const SizedBox(width: 10.0,),
                         Container(
                           width: 100.0,
                           height: 50.0,
                           decoration: BoxDecoration(
                             boxShadow: BoxDecoratinStyes.CustomeBoxshadow,
                             border: BoxDecoratinStyes.CustomeBorder,
                             color: Colors.grey[300],
                             borderRadius: BorderRadius.circular(30.0)
                           ),
                           child: ElevatedButton(onPressed: (){},
                             style: CustomeElevatedButtonStyle.customeStyle(Colors.green[400], Colors.white, Colors.white),
                             child: Text("Sell", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                           ),
                         )
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       );
     }


  }
}
