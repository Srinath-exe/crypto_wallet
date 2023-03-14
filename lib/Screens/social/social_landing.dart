import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/social/Chat_screen.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';

class SocialLanding extends StatefulWidget {
  const SocialLanding({super.key});

  @override
  State<SocialLanding> createState() => _SocialLandingState();
}

class _SocialLandingState extends State<SocialLanding> {
  SocialController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Friends",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Obx(() => StreamBuilder(
                  stream: controller.getAllUsers(),
                  builder: (context, users) {
                    if (users.connectionState == ConnectionState.waiting) {
                      return showLoading();
                    }
                    return GridView.builder(
                      itemCount: users.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 13 / 9),
                      itemBuilder: (context, index) {
                        return chatTile(user: users.data![index])
                            .animate()
                            .flipH()
                            .fadeIn();
                      },
                    );
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Contacts",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            GridView.builder(
              itemCount: users.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
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
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(
            height: 12,
          ),
          Text(
            user.name!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: kWhite),
          ),
        ],
      ),
    );
  }
}
