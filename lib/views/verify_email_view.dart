// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mynoteapp/constants/routes.dart';
import 'package:mynoteapp/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Column(
        children: [
          const Text(
            'Please Verify Your Email address.\nAn  email verification has been sent to your email address.',
          ),
          const Text(
              "If you havn't received verification email. Please press the button below."),
          TextButton(
            onPressed: () async {
              AuthService.firebase().currentUser;
              await AuthService.firebase().sendEmailVerificaiton();
            },
            child: const Text('Send Email Verification again'),
          ),
          const Text(
              'If you\'ve verified your email press the button to login'),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
