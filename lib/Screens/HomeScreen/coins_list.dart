import 'package:crypto_wallet/Model/coinModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinsList extends StatefulWidget {
  const CoinsList({super.key});

  @override
  State<CoinsList> createState() => _HomeState();
}

class _HomeState extends State<CoinsList> {
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
      padding: EdgeInsets.only(),
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
              : ListView.builder(
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
}
