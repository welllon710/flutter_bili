import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const Color _panelColor = Color(0xFF132131);
  static const Color _panelBorderColor = Color(0xFF314151);
  static const Color _primaryBlue = Color(0xFF72C7FF);
  static const Color _secondaryText = Color(0xFF7E8EA1);
  static const Color _titleText = Color(0xFFF1F6FB);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF081321), Color(0xFF050C15)],
          ),
        ),
        child: Stack(
          children: [
            const _BackgroundGlow(alignment: Alignment.topLeft, size: 220),
            const _BackgroundGlow(
              alignment: Alignment.centerRight,
              size: 180,
              opacity: 0.12,
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  8,
                  24,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      const SizedBox(height: 34),
                      _buildLogo(),
                      const SizedBox(height: 20),
                      Text(
                        '五月食伍',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: _titleText,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '发现更多有趣鹤视频',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 34),
                      _buildLoginMethodSwitcher(theme),
                      const SizedBox(height: 16),
                      _buildPhoneField(theme),
                      const SizedBox(height: 14),
                      _buildCredentialField(theme),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: controller.isCodeLogin ? 0 : 1,
                          child: IgnorePointer(
                            ignoring: controller.isCodeLogin,
                            child: Text(
                              '忘记密码?',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _secondaryText,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildLoginButton(theme),
                      const SizedBox(height: 22),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          children: const <InlineSpan>[
                            TextSpan(text: '还没有账号？'),
                            TextSpan(
                              text: ' 立即注册',
                              style: TextStyle(
                                color: _primaryBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 88),
                      _buildOtherLogin(theme),
                      const SizedBox(height: 22),
                      _buildSocialRow(theme),
                      const SizedBox(height: 28),
                      _buildPolicyRow(theme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFF5F9FE), Color(0xFFDCE7F3)],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.explore_rounded, size: 40, color: Color(0xFF111D29)),
      ),
    );
  }

  Widget _buildLoginMethodSwitcher(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              title: '手机登录',
              selected: controller.loginMethodIndex.value == 0,
              onTap: () => controller.changeLoginMethod(0),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              title: '验证码登录',
              selected: controller.loginMethodIndex.value == 1,
              onTap: () => controller.changeLoginMethod(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField(ThemeData theme) {
    return _InputShell(
      child: Row(
        children: [
          Text(
            '+86',
            style: theme.textTheme.titleSmall?.copyWith(
              color: _titleText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _secondaryText.withValues(alpha: 0.9),
            size: 20,
          ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white.withValues(alpha: 0.08),
          ),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              focusNode: controller.phoneFocusNode,
              keyboardType: TextInputType.phone,
              onTapOutside: (_) => controller.phoneFocusNode.unfocus(),
              style: const TextStyle(
                color: _titleText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: _inputDecoration('请输入手机号'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialField(ThemeData theme) {
    return _InputShell(
      child: Row(
        children: [
          Icon(
            controller.isCodeLogin
                ? Icons.verified_user_outlined
                : Icons.lock_outline_rounded,
            color: _secondaryText.withValues(alpha: 0.85),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.credentialController,
              focusNode: controller.credentialFocusNode,
              obscureText:
                  controller.isCodeLogin
                      ? false
                      : controller.obscurePassword.value,
              keyboardType:
                  controller.isCodeLogin
                      ? TextInputType.number
                      : TextInputType.visiblePassword,
              onTapOutside: (_) => controller.credentialFocusNode.unfocus(),
              style: const TextStyle(
                color: _titleText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: _inputDecoration(controller.credentialHint),
            ),
          ),
          const SizedBox(width: 8),
          if (controller.isCodeLogin)
            SizedBox(
              height: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '获取验证码',
                  style: TextStyle(
                    color: _primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: 24,
              height: 24,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.togglePasswordVisible,
                child: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _secondaryText.withValues(alpha: 0.85),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF63BEFF), Color(0xFF80D0FF)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x3055B7FF),
              blurRadius: 28,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.submitLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF092032),
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            '登录',
            style: theme.textTheme.titleSmall?.copyWith(
              color: const Color(0xFF092032),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherLogin(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '其他登录方式',
            style: theme.textTheme.bodySmall?.copyWith(
              color: _secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _SocialLoginButton(
          label: 'Telegram',
          icon: Icons.send_rounded,
          iconColor: Color(0xFF39A9FF),
        ),
        _SocialLoginButton(
          label: '微信',
          icon: Icons.forum_rounded,
          iconColor: Color(0xFF3CD15C),
        ),
        _SocialLoginButton(
          label: 'Apple',
          icon: Icons.apple_rounded,
          iconColor: Color(0xFFEAF2FB),
        ),
        _SocialLoginButton(
          label: 'Google',
          textIcon: 'G',
          iconColor: Color(0xFFFFCA43),
        ),
      ],
    );
  }

  Widget _buildPolicyRow(ThemeData theme) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.togglePolicy,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color:
                    controller.agreePolicy.value
                        ? _primaryBlue
                        : Colors.white.withValues(alpha: 0.42),
              ),
              color:
                  controller.agreePolicy.value
                      ? _primaryBlue.withValues(alpha: 0.16)
                      : Colors.transparent,
            ),
            child:
                controller.agreePolicy.value
                    ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: _primaryBlue,
                    )
                    : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _secondaryText,
                  fontSize: 12,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
                children: const <InlineSpan>[
                  TextSpan(text: '我已阅读并同意 '),
                  TextSpan(
                    text: '用户协议',
                    style: TextStyle(
                      color: _primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' 和 '),
                  TextSpan(
                    text: '隐私政策',
                    style: TextStyle(
                      color: _primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      isCollapsed: true,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: _secondaryText,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({
    required this.alignment,
    required this.size,
    this.opacity = 0.18,
  });

  final Alignment alignment;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                const Color(0xFF4FB9FF).withValues(alpha: opacity),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputShell extends StatelessWidget {
  const _InputShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: LoginView._panelColor.withValues(alpha: 0.66),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: LoginView._panelBorderColor.withValues(alpha: 0.88),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        // duration: const Duration(milliseconds: 220),
        // curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: <Color>[Color(0xFF27445F), Color(0xFF1C344B)],
                  )
                  : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                selected
                    ? LoginView._primaryBlue
                    : LoginView._secondaryText.withValues(alpha: 0.95),
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    this.icon,
    this.textIcon,
    required this.iconColor,
  });

  final String label;
  final IconData? icon;
  final String? textIcon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Center(
            child:
                icon != null
                    ? Icon(icon, color: iconColor, size: 26)
                    : Text(
                      textIcon ?? '',
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: LoginView._secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
