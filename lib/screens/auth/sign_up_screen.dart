import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/components/email_input_field.dart';
import 'package:merkastu_v2/components/loading_animated_button.dart';
import 'package:merkastu_v2/components/password_input_field.dart';

import '../../components/custom_input_field.dart';
import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import 'log_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController =
        Get.put(SignUpController()); // Initialize controller

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 25,
              )),
        ),
      ),
      body: Form(
        key: signUpController.formKey,
        child: const TabBarAndTabViews(),
      ),
    );
  }
}

class TabBarAndTabViews extends StatefulWidget {
  const TabBarAndTabViews({
    Key? key,
  }) : super(key: key);

  @override
  _TabBarAndTabViewsState createState() => _TabBarAndTabViewsState();
}

class _TabBarAndTabViewsState extends State<TabBarAndTabViews>
    with SingleTickerProviderStateMixin {
  late SignUpController signUpController;

  @override
  void initState() {
    super.initState();
    signUpController = Get.find<SignUpController>();
    signUpController.setTabController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 75.0),
      child: Column(
        children: [
          // TabBar
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: TabBar(
                controller: signUpController.tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  buildTab(index: 0),
                  buildTab(index: 1),
                  buildTab(index: 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: signUpController.tabController,
              children: [
                // First Tab (Personal Info)
                _buildPersonalInfoTab(),

                // Second Tab (Address Info)
                _buildAddressTab(),

                // Third Tab (Login Info)
                _buildLoginInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/images/name.svg'),
          ),
          CustomInputField(
            inputController: TextEditingController(),
            hintText: 'Enter your first name',
            onChanged: (val) => signUpController.firstName.value = val,
          ),
          const SizedBox(height: 16.0),
          CustomInputField(
            inputController: TextEditingController(),
            hintText: 'Enter your last name',
            onChanged: (val) => signUpController.lastName.value = val,
          ),
          const SizedBox(height: 16.0),
          CustomInputField(
            inputController: TextEditingController(),
            hintText: 'Enter your phone number',
            onChanged: (val) => signUpController.phone.value = val,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 5,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: TextEditingController(),
              decoration: InputDecoration(
                  hintText: '9XX-XXX-XXX',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(.75), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: maincolor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: maincolor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: maincolor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  helperText: ' ',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: maincolor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorStyle: const TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
              validator: (value) {
                if (value == null || value.length != 9) {
                  return 'Please enter exactly 9 digits';
                }
                return null;
              },
              onChanged: (val) => signUpController.phone.value = val,
            ),
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
            color: Colors.black,
          ),
          buildFooter(context),
          const SizedBox(
            height: 30,
          ),
          buildNavigationButtons(index: 0),
        ],
      ),
    );
  }

  Widget _buildAddressTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/images/address.svg'),
          ),
          CustomInputField(
            inputController: TextEditingController(),
            hintText: 'Enter your block number',
            onChanged: (val) => signUpController.block.value = val,
          ),
          const SizedBox(height: 16.0),
          CustomInputField(
            inputController: TextEditingController(),
            hintText: 'Enter your room number',
            onChanged: (val) => signUpController.room.value = val,
          ),
          const Divider(
            indent: 30,
            endIndent: 30,
            color: Colors.black,
          ),
          buildFooter(context),
          const SizedBox(
            height: 30,
          ),
          buildNavigationButtons(index: 1),
        ],
      ),
    );
  }

  Widget _buildLoginInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/images/login.svg'),
          ),
          EmailInput(
            inputController: TextEditingController(),
            onChanged: (val) => signUpController.email.value = val,
            formKey: signUpController.formKey,
          ),
          const SizedBox(height: 16.0),
          PasswordInput(
            textEditingController: TextEditingController(),
            hintText: 'Enter your password',
            onChanged: (val) => signUpController.password.value = val,
            formKey: signUpController.formKey,
          ),
          const SizedBox(height: 30),
          Obx(() => signUpController.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: LoadingAnimatedButton(
                    color: maincolor,
                    onTap: () {},
                    child: Text(
                      "Signing up...",
                      style: TextStyle(
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () => signUpController.signUp(),
                  child: const Text("Sign Up"),
                )),
          const Divider(
            indent: 30,
            endIndent: 30,
            color: Colors.black,
          ),
          buildFooter(context),
          const SizedBox(
            height: 30,
          ),
          buildNavigationButtons(index: 2)
        ],
      ),
    );
  }

  Row buildNavigationButtons({required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (index > 0)
          ElevatedButton(
            onPressed: () {
              signUpController.tabController.animateTo(index - 1);
            },
            child: const Text('Previous'),
          ),
        ElevatedButton(
          onPressed: () {
            if (signUpController.validateFieldsForTab(index)) {
              signUpController.tabController.animateTo(index + 1);
            }
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Tab buildTab({required int index}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (index == 1)
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                )
              ],
            ),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: signUpController.tabController.index == index
                    ? const Color(0xFF00E0C2)
                    : Colors.black),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
          if (index == 1)
            Row(
              children: [
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 5,
                  width: 5,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black),
                )
              ],
            ),
        ],
      ),
    );
  }
}

Row buildFooter(BuildContext context) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    // Add a text widget to display "Don't have an account?"
    Text("Already have an account?",
        style: TextStyle(
            color: Colors.grey.shade800,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400)),
    // Add a gesture detector widget to handle the tap event on the link
    GestureDetector(
      onTap: () {
        // Navigate to the RegisterScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      // Add a text widget to display "Register" as a link
      child: Text(" Login",
          style: TextStyle(
              color: maincolor,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400)),
    )
  ]);
}
