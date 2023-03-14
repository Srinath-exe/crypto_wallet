import 'dart:convert';

import 'package:crypto_wallet/Model/chartModel.dart';
import 'package:crypto_wallet/Model/coinModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class CoinsDetail extends StatefulWidget {
  CoinModel selectItem;

  CoinsDetail({required this.selectItem});

  @override
  State<CoinsDetail> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<CoinsDetail> {
  late TrackballBehavior trackballBehavior;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kDarkBlack,
      appBar: AppBar(
        backgroundColor: kDarkBlack,
        foregroundColor: kWhite,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
            )),
        // leadingWidth: 20,
        title: Container(
          height: 60,
          width: Config().deviceWidth(context) * 0.6,
          child: Row(
            children: [
              Image.network(
                widget.selectItem.image,
                width: 40,
                height: 40,
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectItem.id.capitalize!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.selectItem.symbol.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: kBlack,
              child: Icon(
                Icons.more_horiz_rounded,
                color: kWhite,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              headerTile(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: myHeight * 0.08,
                            child: Image.network(widget.selectItem.image)),
                        SizedBox(
                          width: myWidth * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectItem.id,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              widget.selectItem.symbol,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${widget.selectItem.currentPrice}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: kWhite),
                        ),
                        SizedBox(
                          height: myHeight * 0.01,
                        ),
                        Text(
                          '${widget.selectItem.marketCapChangePercentage24H}%',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: widget.selectItem
                                          .marketCapChangePercentage24H >=
                                      0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.015,
                  ),
                  Container(
                    height: myHeight * 0.4,
                    width: myWidth,
                    // color: Colors.amber,
                    child: isRefresh == true
                        ? Center(child: showLoading())
                        : itemChart == null
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: const Center(
                                  child: Text(
                                    'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                primaryXAxis: NumericAxis(
                                  //Hide the gridlines of x-axis
                                  majorGridLines: MajorGridLines(width: 0),
                                  //Hide the axis line of x-axis
                                  axisLine: AxisLine(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                    //Hide the gridlines of y-axis
                                    majorGridLines: MajorGridLines(width: 0),
                                    //Hide the axis line of y-axis
                                    axisLine: AxisLine(width: 0)),
                                borderColor: Colors.transparent,
                                trackballBehavior: trackballBehavior,
                                zoomPanBehavior: ZoomPanBehavior(
                                    enablePinching: true, zoomMode: ZoomMode.x),
                                series: <CandleSeries>[
                                  CandleSeries<ChartModel, int>(
                                      // enableSolidCandles: true,
                                      // enableTooltip: true,
                                      bullColor: kGreen,
                                      showIndicationForSameValues: true,
                                      bearColor: kRed,
                                      dataSource: itemChart!,
                                      xValueMapper: (ChartModel sales, _) =>
                                          sales.time,
                                      lowValueMapper: (ChartModel sales, _) =>
                                          sales.low,
                                      highValueMapper: (ChartModel sales, _) =>
                                          sales.high,
                                      openValueMapper: (ChartModel sales, _) =>
                                          sales.open,
                                      closeValueMapper: (ChartModel sales, _) =>
                                          sales.close,
                                      animationDuration: 55)
                                ],
                              ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Center(
                    child: Container(
                      height: myHeight * 0.03,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: myWidth * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  textBool = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  textBool[index] = true;
                                });
                                setDays(text[index]);
                                getChart();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: myWidth * 0.03,
                                    vertical: myHeight * 0.005),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: textBool[index] == true
                                      ? kGreen
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  text[index],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textBool[index] == true
                                          ? kBlack
                                          : kWhite),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.04,
                  ),
                ],
              ),
              //  Padding(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         children: [
              //           const Text(
              //             'Low',
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.normal,
              //                 color: Colors.grey),
              //           ),
              //           SizedBox(
              //             height: myHeight * 0.01,
              //           ),
              //           Text(
              //             '\$${widget.selectItem.low24H}',
              //             style: const TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.normal,
              //                 color: Colors.black),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         children: [
              //           const Text(
              //             'High',
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.normal,
              //                 color: Colors.grey),
              //           ),
              //           SizedBox(
              //             height: myHeight * 0.01,
              //           ),
              //           Text(
              //             '\$${widget.selectItem.high24H}',
              //             style: const TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.normal,
              //                 color: Colors.black),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         children: [
              //           const Text(
              //             'Vol',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //           SizedBox(
              //             height: myHeight * 0.01,
              //           ),
              //           Text(
              //             '\$${widget.selectItem.totalVolume}M',
              //             style: const TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                height: myHeight * 0.1,
                width: myWidth,
                // color: Colors.amber,
                child: Column(
                  children: [
                    const Divider(),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: myHeight * 0.015),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xffFBC700)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight * 0.02,
                                ),
                                const Text(
                                  'Add to portfolio',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url =
        'https://api.coingecko.com/api/v3/coins/${widget.selectItem.id}/ohlc?vs_currency=usd&days=$days';

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }

  headerTile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 20,
        shadowColor:
            widget.selectItem.marketCapChangePercentage24H >= 0 ? kGreen : kRed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.selectItem.marketCapChangePercentage24H >= 0
                ? kGreen
                : kRed,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.selectItem.name} price",
                  style: const TextStyle(
                      color: kBlack,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      widget.selectItem.currentPrice.toString(),
                      style: const TextStyle(
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                    Icon(widget.selectItem.marketCapChangePercentage24H >= 0
                        ? Icons.arrow_outward_rounded
                        : Icons.trending_down_rounded),
                    Expanded(
                      child: Text(
                        "${widget.selectItem.priceChange24H} (${widget.selectItem.marketCapChangePercentage24H.toPrecision(2)}%)",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: kBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
