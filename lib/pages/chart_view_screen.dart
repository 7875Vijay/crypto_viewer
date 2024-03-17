import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
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
  String urlOfSpacificCrypto = "";
  ChartView({required this.urlOfSpacificCrypto});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
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
    String url = 'https://api.coincap.io/v2/assets/${widget.urlOfSpacificCrypto}/history?interval=d1';
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    List<CryptoData> updatedCryptoDataList = [];
    for (var item in responseData['data']) {
      CryptoData cryptoData = CryptoData(
          priceUsd: item["priceUsd"],
          date: item["date"],
          time: item["time"]);
      updatedCryptoDataList.add(cryptoData);
    }
    setState(() {
      cryptoDataList = updatedCryptoDataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.urlOfSpacificCrypto)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Crypto Price History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  // titlesData: FlTitlesData(
                  //   leftTitles:AxisTitles(axisNameWidget:SideTitles() ),
                  //   bottomTitles: SideTitles(showTitles: true),
                  // ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: cryptoDataList.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), double.parse(entry.value.priceUsd ?? "0.0"));
                      }).toList(),
                      isCurved: true,
                      color: Colors.green[900],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      
                    ),
                  ],
                  minY: 0,
                  lineTouchData: LineTouchData(enabled: true),
                  gridData: FlGridData(show: true),
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
