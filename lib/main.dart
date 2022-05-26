import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynoteapp/views/login_view.dart';
import 'package:mynoteapp/views/register_view.dart';
import 'package:mynoteapp/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'My Notes App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              showToast(user.toString());
              if (user.emailVerified) {
                showToast('You are a verified user');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const NotesView();
          default:
            showToast('Loading');
            return const Text('');
        }
      },
    );
  }
}

enum MenuAction {
  logout,
  aboutus,
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: ((value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/',
                      (_) => false,
                    );
                  }
                  break;
                case MenuAction.aboutus:
                  showAboutUsDialog(context);
                  break;
              }
            }),
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.aboutus,
                  child: Text('About Us'),
                )
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text('Cancel')),
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(true);
              }),
              child: const Text('Logout')),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> showAboutUsDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('About Us'),
        content: const Text('This app is developed by Android Alpha Team.'),
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text('Close')),
        ],
      );
    },
  ).then((value) => value ?? false);
}

void showToast(String string) {
  Fluttertoast.showToast(
    msg: string,
    backgroundColor: Colors.red,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}
