import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_wallet/Model/coinModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/HomeScreen/Coin_detail.dart';
import 'package:crypto_wallet/Screens/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CoinsList extends StatefulWidget {
  const CoinsList({super.key});

  @override
  State<CoinsList> createState() => _HomeState();
}

class _HomeState extends State<CoinsList> {
  int selected = 0;
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(),
      child: isRefreshing == true
          ? Center(child: showLoading())
          : coinMarket == null || coinMarket!.length == 0
              ? Padding(
                  padding: EdgeInsets.all(myHeight * 0.06),
                  child: const Center(
                    child: Text(
                      'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Wallet Assets",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: kWhite),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: Config().deviceWidth(context),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(coinMarket!.length, (index) {
                            return card2(coinMarket![index]);
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    topMenu(),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coinMarket!.length,
                      itemBuilder: (context, index) {
                        return CoinCard(
                          item: coinMarket![index],
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
    return [];
  }

  card2(CoinModel coin) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: ZoomTapAnimation(
          onTap: () {
            Nav().goTo(
                CoinsDetail(
                  selectItem: coin,
                ),
                context);
          },
          child: Container(
            height: 260,
            width: Config().deviceWidth(context) * 0.42,
            decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kGreen),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: Config().deviceWidth(context) * 0.4,
                  child: Row(
                    children: [
                      Image.network(
                        coin.image,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.id.capitalize!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    width: Config().deviceWidth(context) * 0.42,
                    child: Sparkline(
                      data: coin.sparklineIn7D.price,
                      lineWidth: 1.2,
                      useCubicSmoothing: true,
                      cubicSmoothingFactor: 0.9,
                      lineColor: coin.marketCapChangePercentage24H >= 0
                          ? kGreen
                          : kRed,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          // stops: const [0.0, 0.7],
                          colors: coin.marketCapChangePercentage24H >= 0
                              ? [kGreen.withOpacity(0.4), kWhite]
                              : [kRed.withOpacity(0.4), kWhite]),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$ ${coin.currentPrice}",
                              style: const TextStyle(
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      coin.marketCapChangePercentage24H >= 0
                                          ? Icons.arrow_outward_rounded
                                          : Icons.trending_down_rounded,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "${coin.marketCapChangePercentage24H.toPrecision(2)}%",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: kBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  topMenu() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          chip("Watchlist", 0),
          chip("Assets", 1),
          chip("Top Gainers", 2),
          chip("Top Losers", 3)
        ]),
      ),
    );
  }

  Widget chip(String catergory, int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: ZoomTapAnimation(
        onTap: () {
          setState(() {
            selected = id;
          });
        },
        child: Chip(
          side: BorderSide.none,
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
            child: Text(
              catergory,
              style: TextStyle(
                color: id == selected ? kBlack : kGreen,
              ),
            ),
          ),
          backgroundColor: id == selected ? kGreen : kBlack,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // :
        ),
      ),
    );
  }
}
