import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/profile/CreateProfileScree.dart';
import 'package:crypto_wallet/Screens/widgets/text_field.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  AuthController controller = Get.find();
  bool _passNotVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passNotVisible = true;
  }

  @override
  void dispose() {
    super.dispose();

    signUpEmailController.dispose();
    signUpPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 2.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: const [
                  Text(
                    "Email",
                    style: TextStyle(
                      color: kLightGrey,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const Spacer(),
              textField(
                controller: signUpEmailController,
                hint: "Enter your email",
              ),
              const Spacer(
                flex: 2,
              ),
              const Text(
                "Password",
                style: TextStyle(
                  color: kLightGrey,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              textField(
                controller: signUpPasswordController,
                hint: "Enter your password",
                obscureText: _passNotVisible,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      if (_passNotVisible != true) {
                        _passNotVisible = true;
                      } else {
                        _passNotVisible = false;
                      }
                    });
                  },
                  child: _passNotVisible
                      ? const Icon(
                          Icons.visibility_off,
                          color: kGrey,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: kGrey,
                        ),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              Obx(() => Container(
                    height: constraints.maxHeight * 0.13,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(40)),
                    child: ElevatedButton(
                        onPressed: () async {
                          controller.register(signUpEmailController.text,
                              signUpPasswordController.text);

                          Nav().goTo(const EditProfile(), context);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: kGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: controller.isLoading.value
                            ? showLoading()
                            : const Text(
                                "Sign up",
                                style: TextStyle(
                                  color: kBlack,
                                  //fontFamily: "MYRIADPRO",
                                  fontSize: 15,
                                ),
                              )),
                  )),
              const Spacer(
                flex: 1,
              ),
              const Text(
                "Or sign up with",
                textAlign: TextAlign.center,
                style: TextStyle(color: kGrey, fontSize: 13),
              ),
              const Spacer(
                flex: 1,
              )
            ],
          );
        },
      ),
    );
  }
}
