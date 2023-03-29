import 'dart:developer';
import 'dart:io';

import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  ImagePicker imagePicker = ImagePicker();
  bool showError = false;
  bool isPhotoLoading = false;
  String? photoUrl;
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  String? newUserName;
  String? newPhoneNumber;
  AuthController socialMediaController = Get.find();

  @override
  void dispose() {
    userNameEditingController.dispose();
    phoneNumberEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    userNameEditingController.text =
        socialMediaController.currentUser.value.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kWhite,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kBlack,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 24,
            ),
            onPressed: () {
              // if (newUserName != null) {
              //   socialMediaController.updateName(name: newUserName!);
              // }
              // if (photoUrl != null) {
              //   socialMediaController.updateProfileImage(profileUrl: photoUrl!);
              // }
              // if (newPhoneNumber != null) {
              //   socialMediaController.updatePhoneNumber(
              //       phoneNumber: newPhoneNumber!);
              // }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: kBlack,
      body: Obx(() {
        if (socialMediaController.currentUser.value == null) {
          return showLoading();
        }
        return SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              children: [
                isPhotoLoading
                    ? const CircleAvatar(
                        radius: 60,
                        backgroundColor: kWhite,
                        child: CupertinoActivityIndicator())
                    : profilePic(
                        padding: const EdgeInsets.all(12),
                        height: 120,
                        url:
                            socialMediaController.currentUser.value.profileUrl),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {});
                    isPhotoLoading = true;
                    photoUrl = await uploadPic();
                    setState(() {});
                    isPhotoLoading = false;
                  },
                  child: const Text(
                    "Change Photo",
                    style: TextStyle(
                        color: kGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ),

                showError
                    ? const Text(
                        "Select an Image",
                        style: TextStyle(color: kRed),
                      )
                    : Container(),

                const SizedBox(
                  height: 5.0,
                ),
                element(
                  name: "Username",
                  icon: Icons.person,
                  controller: userNameEditingController,
                  onChanged: (String? value) {
                    newUserName = value;
                  },
                ),
                element(
                  name: "Phone",
                  icon: Icons.call,
                  controller: phoneNumberEditingController,
                  onChanged: (String? value) {
                    newPhoneNumber = value;
                  },
                ),
                tile(
                    onTap: () {
                      socialMediaController.signOut();
                    },
                    title: "Log Out",
                    icon: Icons.logout),
                const SizedBox(
                  height: 5.0,
                ),
                // const Text('Edit Close Friends'),
              ],
            ),
          ),
        );
      }),
    );
  }

  tile(
      {required String title,
      IconData? icon,
      String? url,
      required Function() onTap}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
      minVerticalPadding: 2,
      dense: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      leading: icon != null
          ? Icon(
              icon,
              color: kWhite,
            )
          : Container(
              width: 30,
              alignment: Alignment.centerLeft,
              child: Image.asset(
                url!,
                width: 20,
              ),
            ),
    );
  }

  Future<String> uploadPic() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    final imgRef = firebaseStorage
        .ref("vendors")
        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    try {
      TaskSnapshot task = await imgRef.putFile(File(selectedImage!.path));

      return task.ref.getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  element({
    required String name,
    required IconData icon,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 0),
                child: Icon(
                  icon,
                  color: kWhite,
                  size: 24,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kWhite,
                ),
              )
            ],
          ),
          TextFormField(
            controller: controller,
            style: const TextStyle(
                color: kWhite, fontWeight: FontWeight.w400, fontSize: 15),
            cursorColor: kWhite,
            onChanged: onChanged,
            decoration: InputDecoration(
                focusColor: kBlack,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE9E9E9)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kWhite, width: 1),
                ),
                hintText: name,
                contentPadding: const EdgeInsets.only(bottom: -10)),
            // initialValue: controller.value.text,
            textInputAction: TextInputAction.next,
            autofocus: true,
          ),
        ],
      ),
    );
  }
}
