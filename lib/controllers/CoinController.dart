import 'dart:developer';

import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/coin_short.dart';
import 'package:crypto_wallet/Models/News_models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CoinController extends GetxController {
  RxBool isLoading = true.obs;
  var newsList = <NewsModel>[].obs;

  var Allnews = NewsModel().obs;
  CoinGeckoApi api = CoinGeckoApi();
  @override
  void onInit() {
    super.onInit();
    getNewsArticles();
    // fetchCoins();
  }

  // Future<void> fetchCoins() async {
  //   try {
  //     isLoading(true);
  //     var response = await http.get(
  //       Uri.parse(apiEndpointUrl),
  //     );
  //     coinsList.value = coinModalFromJson(response.body);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<CoinGeckoResult<List<CoinShort>>> getListofCoins() async {
    return api.coins.listCoins();
    // CoinShort coin = CoinShort();
  }

  getNewsArticles() async {
    isLoading = true.obs;
    var response = await http.get(
        Uri.parse(
            "https://cryptocurrency-news2.p.rapidapi.com/v1/cointelegraph"),
        headers: {
          'X-RapidAPI-Key':
              '7a1349f4d2msh95b1e99c2a27094p1853a1jsn982d9d53de2f',
          'X-RapidAPI-Host': 'cryptocurrency-news2.p.rapidapi.com'
        });
    // log(response.body);
    if (response != null) {
      Allnews.value = newsModelFromJson(response.body);
    }
    log("Updat?");
  }
}
