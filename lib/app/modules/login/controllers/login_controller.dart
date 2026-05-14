import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginController extends GetxController {
  final RxInt loginMethodIndex = 0.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool agreePolicy = false.obs;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController credentialController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode credentialFocusNode = FocusNode();

  bool get isCodeLogin => loginMethodIndex.value == 1;

  String get credentialHint => isCodeLogin ? '请输入验证码' : '请输入密码';

  void changeLoginMethod(int index) {
    if (loginMethodIndex.value == index) return;
    loginMethodIndex.value = index;
    credentialController.clear();
  }

  void togglePasswordVisible() {
    obscurePassword.toggle();
  }

  void togglePolicy() {
    agreePolicy.toggle();
  }

  void submitLogin() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void onClose() {
    phoneFocusNode.dispose();
    credentialFocusNode.dispose();
    phoneController.dispose();
    credentialController.dispose();
    super.onClose();
  }
}
