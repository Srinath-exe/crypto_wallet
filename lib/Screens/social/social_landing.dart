import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ternav_icons/ternav_icons.dart';

class SocialLanding extends StatefulWidget {
  const SocialLanding({super.key});

  @override
  State<SocialLanding> createState() => _SocialLandingState();
}

class _SocialLandingState extends State<SocialLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            GridView.builder(
              itemCount: users.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 13 / 9),
              itemBuilder: (context, index) {
                return chatTile(user: users[index]).animate().flipH().fadeIn();
              },
            )
          ],
        ),
      )),
    );
  }

  Widget chatTile({required UserModel user}) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: Image.network(user.profileUrl!, fit: BoxFit.cover, width: 20,
                loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            user.name!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: kWhite),
          ),
        ],
      ),
    );
  }
}
