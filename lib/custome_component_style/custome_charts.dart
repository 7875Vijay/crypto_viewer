import 'dart:convert';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

class CustomeCharts extends StatefulWidget {
  final String id;
   CustomeCharts({required this.id});

  @override
  State<CustomeCharts> createState() => _CustomeChartsState();
}

class _CustomeChartsState extends State<CustomeCharts> {
  var cryptoDataList = [];

  Future<void> getHistoryData(String id) async {
    if (id.isEmpty) {
      return; // Return if URL is empty or null
    }

    String url = 'https://api.coincap.io/v2/assets/${id}/history?interval=d1';


    try {
      final response = await getResponce(url);

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

  Future<dynamic>getResponce(String url)async{
    return await http.get(Uri.parse(url));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistoryData(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    List<double> listoflinedat = [];
    if(cryptoDataList.length!=0){
      listoflinedat = cryptoDataList.map((data) => double.parse(data.priceUsd)).toList();
    }
    if(listoflinedat.length!=0) {
      return Container(
        height: 50,
        width: 80,
        padding: EdgeInsets.all(2.0),
        child: Sparkline(
          lineColor: Colors.blue,
          data: listoflinedat,

          useCubicSmoothing: true,
          cubicSmoothingFactor: 0.2,
          //fillMode: FillMode.below,

          gridLinelabelPrefix: '\$',
          gridLineLabelPrecision: 3,
          gridLineLabelColor: Colors.white,

          pointsMode: PointsMode.last,
          pointIndex: 7,
          pointSize: 5.0,

          pointColor: Colors.red,

        ),

      );
    }
    else{
      return CupertinoActivityIndicator(
        color: Colors.blue[900],
        animating: true,
        radius: 20,
      );

    }
  }
}
