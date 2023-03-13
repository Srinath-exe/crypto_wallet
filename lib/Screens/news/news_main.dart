import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlack,
      body: SafeArea(child: Image.asset('assets/images/News.png')),
    );
  }
}
