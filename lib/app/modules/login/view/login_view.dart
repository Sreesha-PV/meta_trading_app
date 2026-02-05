// login_signup_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/modules/login/controller/login_controller.dart';

class LoginSignupPage extends StatelessWidget {
  // LoginSignupPage({super.key});

  final AuthController authController = Get.put(AuthController());

  LoginSignupPage({super.key}) {
    // authController.emailController.text = 'Enid.Powlowski62@hotmail.com';
    // authController.passwordController.text = 'rootroot';
    // authController.emailController.text = 'Ova23@gmail.com';
    // authController.passwordController.text = 'rootroot';
    authController.emailController.text = 'test1@gmail.com';
    authController.passwordController.text = '12345678';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(authController.isLogin.value ? 'Login' : 'Sign Up'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => Column(
            children: [
              if (!authController.isLogin.value) ...[
                TextField(
                  controller: authController.firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: authController.lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: authController.accountTypeController,
                  decoration: const InputDecoration(labelText: 'Account Type'),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: authController.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: authController.passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () => authController.submit(context),
                    child: Text(
                      authController.isLogin.value ? 'Login' : 'Sign Up',
                    ),
                  ),
              TextButton(
                onPressed: authController.toggleForm,
                child: Text(
                  authController.isLogin.value
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
