import 'package:flutter/material.dart';
import 'package:mynoteapp/constants/routes.dart';
import 'package:mynoteapp/enums/menu_action.dart';
import 'package:mynoteapp/services/auth/auth_service.dart';

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
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
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
