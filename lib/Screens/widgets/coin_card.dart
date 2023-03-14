import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_wallet/Model/coinModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/HomeScreen/Coin_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';

class CoinCard extends StatefulWidget {
  CoinModel item;
  CoinCard({super.key, required this.item});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: InkWell(
        onTap: () {
          Nav().goTo(
              CoinsDetail(
                selectItem: widget.item,
              ),
              context);
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(
                  widget.item.image,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.id.capitalize!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.item.symbol.toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Config().deviceWidth(context) * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 20,
                    width: Config().deviceWidth(context) * 0.3,
                    child: Sparkline(
                      data: widget.item.sparklineIn7D.price,
                      lineWidth: 1.2,
                      useCubicSmoothing: true,
                      cubicSmoothingFactor: 0.9,
                      lineColor: widget.item.marketCapChangePercentage24H >= 0
                          ? kGreen
                          : kRed,
                      fillMode: FillMode.below,
                      fillGradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.7],
                          colors: widget.item.marketCapChangePercentage24H >= 0
                              ? [kGreen.withOpacity(0.4), kBlack]
                              : [kRed.withOpacity(0.4), kBlack]),
                    ),
                  ),
                ),
                SizedBox(
                  width: Config().deviceWidth(context) * 0.04,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.item.currentPrice.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.item.marketCapChangePercentage24H >= 0 ? "+" : ""} ${widget.item.marketCapChangePercentage24H.toStringAsFixed(2)}%',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    widget.item.marketCapChangePercentage24H >=
                                            0
                                        ? kGreen
                                        : kRed),
                          ),
                          widget.item.marketCapChangePercentage24H >= 0
                              ? Icon(
                                  TernavIcons.bold.arrow_up_1,
                                  size: 12,
                                  color: kGreen,
                                )
                              : Icon(
                                  TernavIcons.light.arrow_down_1,
                                  size: 12,
                                  color: kRed,
                                )
                        ],
                      ),
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
