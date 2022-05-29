// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynoteapp/services/auth/auth_exceptions.dart';
import 'package:mynoteapp/services/auth/auth_service.dart';
import 'package:mynoteapp/utilities/show_error_dialog.dart';
import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'E-mail',
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerificaiton();

                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'The Password is to weak. \nProvide atleast six characters.',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Email is already Registered',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'This is an invalid Email address.',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account. Login'))
        ],
      ),
    );
  }
}
