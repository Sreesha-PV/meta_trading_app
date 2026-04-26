import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/modules/login/controller/login_controller.dart';

class LoginSignupPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  LoginSignupPage({super.key}) {
    authController.emailController.text = 'sreesha@pride.com';
    authController.passwordController.text = 'rootroot';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1923) : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogoSection(isDark),
              const SizedBox(height: 8),
              _buildBadge(isDark),
              const SizedBox(height: 24),

              if (!authController.isLogin.value) ...[
                _buildLabel('First Name', isDark),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: authController.firstNameController,
                  hint: 'Enter your first name',
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _buildLabel('Last Name', isDark),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: authController.lastNameController,
                  hint: 'Enter your last name',
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _buildLabel('Account Type', isDark),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: authController.accountTypeController,
                  hint: 'e.g. Standard, Premium',
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
              ],

              _buildLabel('Email Address', isDark),
              const SizedBox(height: 6),
              _buildTextField(
                controller: authController.emailController,
                hint: 'user@company.com',
                isDark: isDark,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildLabel('Password', isDark),
              const SizedBox(height: 6),
              _buildPasswordField(isDark),
              const SizedBox(height: 8),

              if (authController.isLogin.value)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password? Reset',
                      style: TextStyle(
                        color: Color(0xFF1A6BFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              authController.isLoading.value
                  ? const CircularProgressIndicator(color: Color(0xFF1A6BFF))
                  : _buildLoginButton(context),

              const SizedBox(height: 24),
              _buildDivider(isDark),
              const SizedBox(height: 16),
              _buildSignupToggle(isDark),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildLogoSection(bool isDark) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1A6BFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Meta Trade',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: isDark ? Colors.white : const Color(0xFF0F1923),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Professional Trading Platform',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFF7A8499),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C2A3A) : const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFC0D4FF),
        ),
      ),
      child: Text(
        'Secure Login',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFF1A6BFF),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFF7A8499),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F1923),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF3A4D63) : const Color(0xFFAAB0BE),
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1C2A3A) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    final obscure = true.obs;
    return Obx(() => TextField(
      controller: authController.passwordController,
      obscureText: obscure.value,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F1923),
      ),
      decoration: InputDecoration(
        hintText: '••••••••••',
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF3A4D63) : const Color(0xFFAAB0BE),
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1C2A3A) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        suffixIcon: IconButton(
          icon: Icon(
            obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18,
            color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFFAAB0BE),
          ),
          onPressed: () => obscure.value = !obscure.value,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5),
        ),
      ),
    ));
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => authController.submit(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A6BFF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          authController.isLogin.value ? 'Sign In' : 'Create Account',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ));
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            authController.isLogin.value ? 'New here?' : 'Have an account?',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFFAAB0BE),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? const Color(0xFF2A3D54) : const Color(0xFFDDE3ED),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSignupToggle(bool isDark) {
    return Obx(() => GestureDetector(
      onTap: authController.toggleForm,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF6B7FA3) : const Color(0xFF7A8499),
          ),
          children: [
            TextSpan(
              text: authController.isLogin.value
                  ? "Don't have an account? "
                  : "Already have an account? ",
            ),
            const TextSpan(
              text: 'Create one',
              style: TextStyle(
                color: Color(0xFF1A6BFF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}