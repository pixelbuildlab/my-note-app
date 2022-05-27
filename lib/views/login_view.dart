// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mynoteapp/services/auth/auth_exceptions.dart';
import 'package:mynoteapp/services/auth/auth_service.dart';
import 'package:mynoteapp/utilities/show_toast.dart';
import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _validateEmail = false;
  bool _validatePass = false;
  bool _isObsecure = true;
  @override
  void initState() {
    _email = TextEditingController();

    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-mail',
              labelText: 'E-mail',
              errorText: _validateEmail ? 'Email field is empty.' : null,
            ),
          ),
          TextField(
            controller: _password,
            obscureText: _isObsecure,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              errorText: _validatePass ? 'Password field is empty.' : null,
              suffixIcon: IconButton(
                  onPressed: (() {
                    setState(() {
                      _isObsecure = !_isObsecure;
                    });
                  }),
                  icon: Icon(
                      _isObsecure ? Icons.visibility : Icons.visibility_off)),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              setState(() {
                email.isEmpty ? _validateEmail = true : _validateEmail = false;
                password.isEmpty ? _validatePass = true : _validatePass = false;
              });
              if (!_validateEmail && !_validatePass) {
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    showToast('Please verify email before continue');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'No registered user found.\nEmail is not registered',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Incorrect Password!',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication erro',
                  );
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register Now!'))
        ],
      ),
    );
  }
}
