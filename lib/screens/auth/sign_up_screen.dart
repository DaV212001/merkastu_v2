import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/loading_animated_button.dart';
import '../../widgets/password_input_field.dart';
import 'log_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController =
        Get.put(SignUpController()); // Initialize controller

    return Scaffold(
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
  late TabController tabController;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    signUpController = Get.find<SignUpController>();
    tabController = TabController(length: 3, vsync: this);
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
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: TabBar(
                controller: tabController,
                dividerColor: Colors.transparent,
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
              controller: tabController,
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey1,
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
                inputController: TextEditingController(
                    text: signUpController.firstName.value),
                hintText: 'Enter your first name',
                onChanged: (val) => signUpController.firstName.value = val,
              ),
              const SizedBox(height: 16.0),
              CustomInputField(
                inputController: TextEditingController(
                    text: signUpController.lastName.value),
                hintText: 'Enter your last name',
                onChanged: (val) => signUpController.lastName.value = val,
              ),
              const SizedBox(height: 16.0),
              const Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.black,
              ),
              buildFooter(context),
              const SizedBox(
                height: 30,
              ),
              buildNavigationButtons(index: 0, formKey: _formKey1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey2,
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
                inputController:
                    TextEditingController(text: signUpController.block.value),
                keyboardType: TextInputType.number,
                hintText: 'Enter your block number',
                onChanged: (val) => signUpController.block.value = val,
                validator: (value) {
                  if (value!.length > 2) {
                    return 'Block number can only be 2 digits';
                  }
                  if (!value.isNumericOnly) {
                    return 'Block number can only contain numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomInputField(
                inputController:
                    TextEditingController(text: signUpController.room.value),
                keyboardType: TextInputType.number,
                hintText: 'Enter your room number',
                onChanged: (val) => signUpController.room.value = val,
                validator: (value) {
                  if (value!.length > 3) {
                    return 'Room number can only be 3 digits';
                  }
                  if (!value.isNumericOnly) {
                    return 'Room number can only contain numbers';
                  }
                },
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
              buildNavigationButtons(index: 1, formKey: _formKey2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey3,
          child: SingleChildScrollView(
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
                const Text(
                  'Please enter a phone number associated with your Telegram account',
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(
                  height: 5,
                ),
                PhoneNumberInput(
                  textEditingController:
                      TextEditingController(text: signUpController.phone.value),
                  onChanged: (val) => signUpController.phone.value = val,
                ),
                PasswordInput(
                  textEditingController: TextEditingController(
                      text: signUpController.password.value),
                  hintText: 'Enter your password',
                  onChanged: (val) => signUpController.password.value = val,
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
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey3.currentState!.validate()) {
                              signUpController.signUp();
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: secondarycolor),
                          ),
                        ),
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
                buildNavigationButtons(index: 2, formKey: _formKey3)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildNavigationButtons(
      {required int index, required GlobalKey<FormState> formKey}) {
    return Row(
      mainAxisAlignment:
          index == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      children: [
        if (index > 0)
          ElevatedButton(
            onPressed: () {
              tabController.animateTo(index - 1);
              setState(() {});
            },
            child: Text(
              'Previous',
              style: TextStyle(color: secondarycolor),
            ),
          ),
        if (index != 2)
          ElevatedButton(
            onPressed: () {
              if (signUpController.validateFieldsForTab(index)) {
                if (formKey.currentState!.validate()) {
                  tabController.animateTo(index + 1);
                  setState(() {});
                }
              }
            },
            child: Text(
              'Next',
              style: TextStyle(color: secondarycolor),
            ),
          ),
      ],
    );
  }

  Tab buildTab({required int index}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tabController.index == index ? maincolor : Colors.black),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                    color: tabController.index == index
                        ? secondarycolor
                        : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    required this.textEditingController,
    this.onChanged,
  });

  final TextEditingController textEditingController;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 56.5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  top: BorderSide(color: maincolor, width: 1),
                  bottom: BorderSide(color: maincolor, width: 1),
                  left: BorderSide(color: maincolor, width: 1),
                  right: BorderSide(color: maincolor, width: 1),
                )),
            child: const Center(
                child: Text(
              '+251',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            )),
          ),
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
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: '9XX-XXX-XXX',
              hintStyle: const TextStyle(fontSize: 14),
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
                  fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.length != 9) {
                return 'Please enter exactly 9 digits';
              }
              return null;
            },
            onChanged: onChanged,
          ),
        ),
      ],
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
              fontWeight: FontWeight.bold)),
    )
  ]);
}
