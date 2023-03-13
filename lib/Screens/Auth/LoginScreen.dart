import 'package:crypto_wallet/Screens/Auth/signUp.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/widgets/f&g_button.dart';
import 'package:crypto_wallet/Screens/widgets/text_field.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthController controller = Get.find();
  final TextEditingController emailController = TextEditingController();
  bool isSelected = true;
  bool loading = false;
  final TextEditingController emailPasswordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController mobilePasswordController =
      TextEditingController();

  late bool showPassword;
  @override
  void initState() {
    super.initState();
    isSelected = true;
    showPassword = true;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailPasswordController.dispose();
    mobileController.dispose();
    mobilePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(
                flex: 10,
              ),
              Container(
                height: height * 0.050,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: kDarkBlack, borderRadius: BorderRadius.circular(12)),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                            print("Sign In: $isSelected");
                          });
                        },
                        child: Container(
                          width: constraints.maxWidth / 2,
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: kBlack,
                                  borderRadius: BorderRadius.circular(10),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  color: isSelected ? kWhite : kGrey,
                                  fontFamily: "MYRIADPRO"),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                            print("Sign Up: $isSelected");
                          });
                        },
                        child: Container(
                          width: constraints.maxWidth / 2,
                          decoration: isSelected
                              ? null
                              : BoxDecoration(
                                  color: kBlack,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                          child: Center(
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: isSelected ? kGrey : kWhite,
                                  fontFamily: "MYRIADPRO"),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              const Spacer(
                flex: 12,
              ),
              // Sign UP Text
              isSelected
                  ? const Text(
                      "Sign in",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 32,
                      ),
                    )
                  : const Text(
                      "Sign up",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 32,
                      ),
                    ),
              const Spacer(
                flex: 5,
              ),
              isSelected ? signInLayout() : const SignUp(),
              const Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  FGButtom(
                    height: height * 0.06,
                    width: width / 2.5,
                    text: "Facebook",
                    image: "assets/images/icons/facebook.png",
                    onTap: () {},
                  ),
                  const Spacer(),
                  FGButtom(
                    height: height * 0.06,
                    width: width / 2.5,
                    text: "Google",
                    image: "assets/images/icons/google.png",
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      controller.googleLogin();
                      setState(() {
                        loading = false;
                      });
                    },
                  )
                ],
              ),
              const Spacer(
                flex: 15,
              ),

              const Spacer(
                flex: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container signInLayout() {
    return Container(
      height: Config().deviceHeight(context) / 2.2,
      child: LayoutBuilder(builder: (context, constraints) {
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
            const Spacer(
              flex: 1,
            ),
            textField(
              controller: emailController,
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
              controller: emailPasswordController,
              hint: "Enter your password",
              obscureText: showPassword,
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: kGreen,
                    size: 12,
                  )),
            ),
            const Spacer(
              flex: 1,
            ),
            const Text(
              "Forgot password?",
              style: TextStyle(
                color: kGreen,
                //fontFamily: "MYRIADPRO",
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            Container(
              height: constraints.maxHeight * 0.13,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    // await context.read<FirebaseAuthMethods>().loginWithEmail(
                    //       email: emailController.text,
                    //       password: emailPasswordController.text,
                    //       context: context,
                    //     );
                    loading = false;
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, AppRoutes.homeScreenRoute, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: kGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                      color: kBlack,
                      //fontFamily: "MYRIADPRO",
                      fontSize: 15,
                    ),
                  )),
            ),
            const Spacer(
              flex: 1,
            ),
            const Text(
              "Or login with",
              textAlign: TextAlign.center,
              style: TextStyle(color: kGrey, fontSize: 13),
            ),
            const Spacer(
              flex: 1,
            )
          ],
        );
      }),
    );
  }
}
