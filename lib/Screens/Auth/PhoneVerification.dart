import 'package:crypto_wallet/Screens/Auth/OTP_screen.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/controllers/AuthController.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController countryController = TextEditingController();
  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  goBack(txt: "Sign Up", context: context),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    "Register with mobile",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Please type your number, then we’ll send a verification code for authentication.",
                    style: TextStyle(fontSize: 14, color: kLightGrey),
                    // textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => TextFormField(
                        initialValue: authController.phoneNo.value,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        cursorColor: kWhite,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1),
                        onTap: () {
                          authController.showPrefix.value = true;
                        },
                        onChanged: (val) {
                          authController.phoneNo.value = val;
                        },
                        onTapOutside: (event) {
                          if (authController.phoneNo.value.isEmpty) {
                            authController.showPrefix.value = false;
                          }
                        },
                        onSaved: (val) => authController.phoneNo.value = val!,
                        validator: (val) => (val!.isEmpty || val.length < 10)
                            ? "Enter valid number"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                          hintStyle:
                              const TextStyle(color: kGrey, fontSize: 14),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kLightGrey),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kWhite),
                              borderRadius: BorderRadius.circular(10)),
                          prefix: authController.showPrefix.value
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '(+91)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: kLightGrey),
                                  ),
                                )
                              : null,
                          suffixIcon: _buildSuffixIcon(),
                        ),
                      )),
                  const SizedBox(
                    height: 22,
                  ),
                  Container(
                    height: 50,
                    width: Config().deviceWidth(context),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(40)),
                    child: ElevatedButton(
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            authController.getOtp();
                            Nav().goTo(const OtpScreen(), context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: kGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(
                              color: kBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return AnimatedOpacity(
        opacity: authController.phoneNo.value.length == 10 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.check_circle, color: Colors.green, size: 32));
  }
}

goBack({required String txt, required BuildContext context}) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Row(
      children: [
        const Icon(
          Icons.arrow_back_outlined,
          color: kLightGrey,
          size: 16,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          txt,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: kLightGrey, fontSize: 18),
        )
      ],
    ),
  );
}
