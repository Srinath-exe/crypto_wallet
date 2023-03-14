import 'dart:developer';

import 'package:coingecko_api/data/coin_short.dart';
import 'package:crypto_wallet/Models/News_models.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/news/webScreen.dart';
import 'package:crypto_wallet/controllers/CoinController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:math' as math;

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  CoinController controller = Get.find();

  List<Color> colors = [
    const Color(0xffFFF8DD),
    const Color(0xffFBE5E1),
    const Color(0xffE1F1FF),
    const Color(0xffECE5FE),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kDarkBlack,
        body: SafeArea(child: Obx(() {
          if (controller.Allnews.value.data == null) {
            return Center(
              child: showLoading(),
            );
          }
          // if (controller.Allnews.value.data == null) {
          //   return const Center(child: Text("API Traffic"));
          // }
          return ListView.builder(
            itemCount: controller.Allnews.value.data!.length,
            itemBuilder: (context, index) {
              if (controller.Allnews.value.data == null) {
                return IconButton(
                    onPressed: () {
                      controller.getNewsArticles();
                    },
                    icon: const Icon(Icons.abc_outlined));
              }
              return newsCard(controller.Allnews.value.data![index]);
            },
          );
        })

            //      FutureBuilder(
            //   future: controller.getListofCoins(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: showLoading());
            //     }
            //     return SingleChildScrollView(
            //       child: Column(
            //         children: List.generate(snapshot.data!.data.length, (index) {
            //           return tile(snapshot.data!.data[index]);
            //         }),
            //       ),
            //     );
            //   },
            // ))
            ));
  }

  tile(CoinShort coin) {
    return Container(
      child: Row(
        children: [Text(coin.name), Text(coin.symbol)],
      ),
    );
  }

  newsCard(Datum news) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: InkWell(
        onTap: () {
          Nav().goTo(WebScreen(url: news.url!), context);
        },
        child: Container(
          width: Config().deviceWidth(context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: kWhite),
          child: Container(
            width: Config().deviceWidth(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kGreen.withOpacity(0.5)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    news.title!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        letterSpacing: 0.6,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kBlack),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    news.description!,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlack),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${news.createdAt!.split("23 ")[0]}23",
                        style: const TextStyle(
                            color: kBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          cell(Icons.thumb_up_off_alt_outlined),
                          cell(Icons.bookmark_outline_rounded),
                          cell(TernavIcons.lightOutline.send),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  cell(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ZoomTapAnimation(
          onTap: () {},
          child: CircleAvatar(
              backgroundColor: kBlack.withOpacity(0.2),
              child: Icon(
                icon,
                color: kBlack,
                size: 16,
              ))),
    );
  }
}
