import 'dart:developer';

import 'package:crypto_wallet/Screens/Auth/PhoneVerification.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

// import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController controller = Get.find();
  bool incomplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlack,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                goBack(txt: "Verification", context: context),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Enter your code",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Please type the code we sent to",
                  style: TextStyle(fontSize: 14, color: kLightGrey),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${controller.phoneNo.value}",
                  style: const TextStyle(fontSize: 14, color: kGreen),
                ),
                const SizedBox(
                  height: 60,
                ),
                Obx(() => Column(
                      children: [
                        OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 40,
                          hasError: controller.isInvalid.value,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          outlineBorderRadius: 50,
                          style: const TextStyle(
                              fontSize: 20,
                              color: kWhite,
                              fontWeight: FontWeight.w600),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.underline,
                          otpFieldStyle: OtpFieldStyle(
                              enabledBorderColor: kLightGrey,
                              focusBorderColor: kGreen),
                          onChanged: (pin) {},
                          onCompleted: (pin) {
                            controller.otp.value = pin;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        incomplete
                            ? const Text(
                                "Incomplete OTP",
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        controller.isInvalid.value
                            ? const Text(
                                "Wrong OTP",
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        ThemeButton(
                            width: Config().deviceWidth(context),
                            height: 55,
                            onTap: () async {
                              if (!controller.isLoading.value) {
                                setState(() {
                                  if (controller.otp.value.length < 6) {
                                    incomplete = true;
                                  } else {
                                    incomplete = false;
                                  }
                                });
                                if (controller.otp.value.length == 6) {
                                  var loggedin = await controller.verifyOTP();
                                  if (loggedin) {
                                    Navigator.pop(context);
                                    log("LOGGED IN SUCCESSFULLY");
                                  }
                                }
                              }
                            },
                            text: "Verify",
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: kBlack,
                                  )
                                : const Text(
                                    "Continue",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: kBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Edit Phone Number ?",
                                  style: TextStyle(color: kLightGrey),
                                ))
                          ],
                        ),
                        controller.isOtpSent.value
                            ? TextButton(
                                style: const ButtonStyle(),
                                onPressed: () => controller.resendOTP.value
                                    ? controller.resendOtp()
                                    : null,
                                child: Text(
                                  controller.resendOTP.value
                                      ? "Resend New Code"
                                      : "Wait ${controller.resendAfter} seconds",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: kLightGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
